//
//  MountainPeaksView.swift
//  White Mountain Four Thousand Footers
//
//  Created by Nathan Beaumont on 11/5/20.
//

import SwiftUI

class MountainDataSource: ObservableObject {
    @Published var mountainPeaks = [MountainPeak]()

    fileprivate func updateSorting(filter: ListFilterView.ListFilterState) {
        switch filter {
            case .elevationDescending:
                mountainPeaks.sort {  $0.elevation > $1.elevation }
            case .elevationAscending:
                mountainPeaks.sort {  $0.elevation < $1.elevation }
            case .alphabeticalAZ:
                mountainPeaks.sort {  $0.name < $1.name }
            case .alphabeticalZA:
                mountainPeaks.sort {  $0.name > $1.name }
        }
    }
}

struct MountainPeaksView: View {

    init() {
        UITableView.appearance().separatorStyle = .none
        UITableView.appearance().backgroundColor = UIColor.clear
        UITableViewCell.appearance().backgroundColor = UIColor.clear
    }

    @ObservedObject fileprivate var mountainDataSource = MountainDataSource()

    var body: some View {
        ZStack {
            GeometryReader { geometry in
                Image("Trail_Path")
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .aspectRatio(contentMode: .fill)

                VStack(alignment: .center, spacing: 15.0) {
                    ListFilterView(mountainDataSource: mountainDataSource)
                        .frame(width: geometry.size.width - 32.0, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                        .background(Color.white)
                        .cornerRadius(15.0)

                    List(mountainDataSource.mountainPeaks, id: \.id) { peak in
                        MountainPeakCell(mountainPeak: peak)
                    }
                    .frame(width: geometry.size.width)
                    .listRowInsets(.none)
                    .listStyle(SidebarListStyle())
                    .onAppear(perform: loadMountainPeaks)
                }
            }
        }
    }



    private func loadMountainPeaks() {
        let apiRequest =  APIRequestFactory.mountainPeaks()
        APIClient.perform(request: apiRequest) { mountainPeaks in
            self.mountainDataSource.mountainPeaks = mountainPeaks
            self.mountainDataSource.updateSorting(filter: .elevationDescending)
        }
    }
}

private struct ListFilterView: View {

    public enum ListFilterState {
        case elevationDescending
        case elevationAscending
        case alphabeticalAZ
        case alphabeticalZA
    }

    // MARK: Reactive Properties
    @ObservedObject fileprivate var mountainDataSource: MountainDataSource
    @State private var listFilterState: ListFilterView.ListFilterState = .elevationDescending


    // MARK: Computed Properties
    private var elevationButtonSelected: Bool {
        return listFilterState == .elevationAscending || listFilterState == .elevationDescending
    }
    private var alphabeticalButtonSelected: Bool {
        return listFilterState == .alphabeticalAZ || listFilterState == .alphabeticalZA
    }

    var body: some View {
        VStack {
            let imageHeight: CGFloat = 34.0
            HStack(spacing: 15.0) {
                Spacer()

                Button(action: elevationButtonPressed) {
                    VStack {
                        Image(systemName: "arrow.up.arrow.down")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: imageHeight)
                        Text("Elevation")
                    }
                    .frame(height: imageHeight)
                }
                .accentColor(elevationButtonSelected ? .blue : .black)

                Button(action: alphabeticalButtonPressed) {
                    VStack {
                        ZStack {
                            Image("Alphabetical_Sort")
                                .renderingMode(.template)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: imageHeight)
                                .layoutPriority(1)
                            Circle()
                                .stroke(alphabeticalButtonSelected ? Color.blue : .black, lineWidth: 3.0)
                                .background(Color.clear)
                        }
                        Text("Alphabetical")
                    }
                }
                .accentColor(alphabeticalButtonSelected ? .blue : .black)

                Spacer()
            }.padding(15.0)
        }
    }

    private func elevationButtonPressed() {
        if listFilterState == .elevationDescending {
            listFilterState = .elevationAscending
        } else if listFilterState == .elevationAscending {
            listFilterState = .elevationDescending
        } else {
            listFilterState = .elevationDescending
        }

        mountainDataSource.updateSorting(filter: listFilterState)
    }

    private func alphabeticalButtonPressed() {
        if listFilterState == .alphabeticalAZ {
            listFilterState = .alphabeticalZA
        } else if listFilterState == .alphabeticalZA {
            listFilterState = .alphabeticalAZ
        } else {
            listFilterState = .alphabeticalAZ
        }

        mountainDataSource.updateSorting(filter: listFilterState)
    }
}

struct MountainPeaksView_Previews: PreviewProvider {
    static var previews: some View {
        MountainPeaksView()
    }
}
