//
//  MountainBag.swift
//  White Mountain Four Thousand Footers
//
//  Created by Nathan Beaumont on 11/28/20.
//

import Foundation

struct MountainBag: Codable {
    let bagId: Int
    let mountainId: Int

    enum CodingKeys: String, CodingKey {
        case bagId = "mountain_bag_id"
        case mountainId = "mountain_id"
    }
}

extension Array where Element == MountainBag {
    func peakHiked(_ mountainPeakId: Int) -> Bool {
        self.contains { peak -> Bool in
            peak.mountainId == mountainPeakId
        }
    }
}

