//
//  MountainPeak.swift
//  White Mountain Four Thousand Footers
//
//  Created by Nathan Beaumont on 11/1/20.
//

import Foundation

struct APIError: Codable {
    let error: String

    enum CodingKeys: String, CodingKey {
        case error
    }
}
