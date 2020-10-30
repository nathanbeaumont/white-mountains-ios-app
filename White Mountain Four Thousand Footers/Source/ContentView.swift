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
            Text("1")
                .tabItem {
                    Image(systemName: "star")
                    Text("One")
                }
            Text("2")
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
