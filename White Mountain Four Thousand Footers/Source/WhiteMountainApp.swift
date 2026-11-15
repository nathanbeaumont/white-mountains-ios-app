//
//  White_Mountain_Four_Thousand_FootersApp.swift
//  White Mountain Four Thousand Footers
//
//  Created by Nathan Beaumont on 10/29/20.
//

import SwiftUI

@main
struct WhiteMountainApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}
