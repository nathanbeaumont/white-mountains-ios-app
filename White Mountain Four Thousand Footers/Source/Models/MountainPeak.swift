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
    let infoUrls: String

    enum CodingKeys: String, CodingKey {
        case ascent
        case elevation
        case id = "mountain_id"
        case latitude
        case longitude
        case name = "mountain_name"
        case infoUrls = "mountain_info_urls"
    }
}

extension MountainPeak {
    var urls: [URL] {
        let strings = infoUrls.split(separator: ",")
        var urls = [URL]()

        for url in strings {
            if let verifiedURL = URL(string: String(url)) {
                urls.append(verifiedURL)
            }
        }

        return urls
    }
}
