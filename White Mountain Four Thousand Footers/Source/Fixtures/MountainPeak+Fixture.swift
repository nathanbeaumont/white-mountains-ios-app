//
//  MountainPeak+Fixture.swift
//  White Mountain Four Thousand Footers
//
//  Created by Nathan Beaumont on 11/6/20.
//

import Foundation

extension MountainPeak {
    struct Fixture {
        static func mountWashingtonPeak() -> MountainPeak {
            return MountainPeak(ascent: 4491,
                                elevation: 6288,
                                id: 1,
                                latitude: 44.2705408,
                                longitude: -71.3034539,
                                name: "Washington")
        }
    }
}
