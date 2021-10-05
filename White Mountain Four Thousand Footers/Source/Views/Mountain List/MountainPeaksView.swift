//
//  MountainPeaksView.swift
//  White Mountain Four Thousand Footers
//
//  Created by Nathan Beaumont on 11/5/20.
//

import Combine
import SwiftUI

struct MountainPeaksView: View {

    init() {
        UITableView.appearance().separatorStyle = .none
        UITableView.appearance().backgroundColor = UIColor.clear
        UITableViewCell.appearance().backgroundColor = UIColor.clear
    }

    var body: some View {
        ZStack {
            GeometryReader { geometry in
                Image("Trail_Path")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)

                VStack(alignment: .center, spacing: 15.0) {
                    ListFilterView()
                        .frame(width: geometry.size.width - 32.0, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)

                    MountainList(geometry: geometry)
                }
            }
        }
    }
}

struct MountainList: View {

    // MARK: Reactive Properties
    let geometry: GeometryProxy
    @ObservedObject fileprivate var mountainDataSource = MountainDataSource.shared
    let publisher = NotificationCenter.default.publisher(for: NSNotification.Name.MountainPeakBagged)

    var body: some View {
        List(mountainDataSource.mountainPeaks, id: \.id) { peak in
            let peakHiked: Bool = mountainDataSource.mountainBags.peakHiked(peak.id)
            if #available(iOS 15.0, *) {
                MountainPeakCell(mountainPeak: peak,
                                 peakHiked: peakHiked)
                    .listRowSeparator(.hidden)
            } else {
                MountainPeakCell(mountainPeak: peak,
                                 peakHiked: peakHiked)
            }
        }
        .frame(width: geometry.size.width)
        .listRowInsets(.none)
        .listStyle(.grouped)
        .onAppear(perform: {
            mountainDataSource.loadMountainPeaks()
            UITableView.appearance().separatorStyle = .none
        })
        .onReceive(publisher, perform: { _ in
            self.mountainDataSource.getPeaksBagged()
        })
    }
}

struct ListFilterView: View {

    public enum ListFilterState {
        case elevationDescending
        case elevationAscending
        case alphabeticalAZ
        case alphabeticalZA
    }

    // MARK: Reactive Properties
    @ObservedObject fileprivate var mountainDataSource = MountainDataSource.shared
    @State private var listFilterState: ListFilterView.ListFilterState = .elevationDescending

    //MARK : Environment Properties
    @Environment(\.colorScheme) var currentMode

    // MARK: Computed Properties
    private var elevationButtonSelected: Bool {
        return listFilterState == .elevationAscending || listFilterState == .elevationDescending
    }
    private var alphabeticalButtonSelected: Bool {
        return listFilterState == .alphabeticalAZ || listFilterState == .alphabeticalZA
    }
    private var unselectedColor: Color {
        currentMode == .dark ?  Color.white : Color.black
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
                .accentColor(elevationButtonSelected ? .blue : unselectedColor)

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
                                .stroke(alphabeticalButtonSelected ? Color.blue : unselectedColor, lineWidth: 3.0)
                                .background(Color.clear)
                        }
                        Text("Alphabetical")
                    }
                }
                .accentColor(alphabeticalButtonSelected ? .blue : unselectedColor)

                Spacer()
            }
            .padding(15.0)
            .background(currentMode == .dark ? Color.black : Color.white)
        }
        .cornerRadius(15.0)
    }

    private func elevationButtonPressed() {
        if listFilterState == .elevationDescending {
            listFilterState = .elevationAscending
        } else if listFilterState == .elevationAscending {
            listFilterState = .elevationDescending
        } else {
            listFilterState = .elevationDescending
        }

        updateDataSource()
    }

    private func alphabeticalButtonPressed() {
        if listFilterState == .alphabeticalAZ {
            listFilterState = .alphabeticalZA
        } else if listFilterState == .alphabeticalZA {
            listFilterState = .alphabeticalAZ
        } else {
            listFilterState = .alphabeticalAZ
        }

        updateDataSource()
    }

    private func updateDataSource() {
        mountainDataSource.objectWillChange.send()
        mountainDataSource.updateSorting(filter: listFilterState)
    }
}

struct MountainPeaksView_Previews: PreviewProvider {
    static var previews: some View {
        MountainPeaksView()
            .preferredColorScheme(.dark)
    }
}
