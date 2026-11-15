//
//  AppConstants.swift
//  White Mountain Four Thousand Footers
//
//  Created by Nathan Beaumont on 1/9/21.
//

import Foundation

struct AppConstants {
    static let appVersion: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""

    struct Database {
        static let MountainPeakEntity = "MountainPeak"
        static let MountainBagEntity = "MountainBagCoreData"
    }

    struct Background {
        /// Asset catalog names of the photos that can be used as the app background.
        static let imageNames = [
            "Trail_Path",
            "Ridge_Path",
            "Snowy_Lookout",
            "Frost_Summit",
            "River_Rocks",
            "Summit_Ridge",
            "Green_Valley"
        ]

        /// Picked once per app launch (static properties are initialized lazily, exactly once).
        static let launchImageName: String = imageNames.randomElement() ?? "Trail_Path"
    }
}
