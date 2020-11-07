//
//  ContentView.swift
//  White Mountain Four Thousand Footers
//
//  Created by Nathan Beaumont on 10/29/20.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        TabView {
            MountainPeaksView()
                .tabItem {
                    Image(systemName: "taskCompleted")
                    Text("Mountain Peaks")
                }
            Text("Map")
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Two")
                }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
