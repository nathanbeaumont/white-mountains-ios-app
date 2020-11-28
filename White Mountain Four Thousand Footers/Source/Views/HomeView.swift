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
                    Image(systemName: "list.dash")
                    Text("Mountain Peaks")
                }
                .background(Color.Custom.backgroundGreen)
            Text("Map")
                .tabItem {
                    Image(systemName: "map.fill")
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
