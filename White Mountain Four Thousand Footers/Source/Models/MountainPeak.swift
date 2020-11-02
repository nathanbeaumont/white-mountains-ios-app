//
//  MountainPeak.swift
//  White Mountain Four Thousand Footers
//
//  Created by Nathan Beaumont on 11/1/20.
//

import Foundation

struct MountainPeak: Codable {
    let ascent: Int
    let elevation: Int
    let id: Int
    let latitude: Double
    let longitude: Double
    let name: String

    enum CodingKeys: String, CodingKey {
        case ascent
        case elevation
        case id = "mountainID"
        case latitude
        case longitude
        case name = "mountainName"
    }
}
