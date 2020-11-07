//
//  MountainPeaksView.swift
//  White Mountain Four Thousand Footers
//
//  Created by Nathan Beaumont on 11/5/20.
//

import SwiftUI

struct MountainPeaksView: View {

    init() {
        UITableView.appearance().separatorStyle = .none
        UITableView.appearance().backgroundColor = UIColor.clear
        UITableViewCell.appearance().backgroundColor = UIColor.clear
    }

    @State private var mountainPeaks = [MountainPeak]()

    var body: some View {
        List(mountainPeaks, id: \.id) { peak in
            MountainPeakCell(mountainPeak: peak)
        }
        .listRowInsets(.none)
        .listStyle(SidebarListStyle())
        .onAppear(perform: loadMountainPeaks)
    }

    private func loadMountainPeaks() {
        let apiRequest =  APIRequestFactory.mountainPeaks()
        APIClient.perform(request: apiRequest) { mountainPeaks in
            self.mountainPeaks = mountainPeaks
        }
    }
}

struct MountainPeaksView_Previews: PreviewProvider {
    static var previews: some View {
        MountainPeaksView()
    }
}
