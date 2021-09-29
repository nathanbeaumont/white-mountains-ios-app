//
//  MountainBag.swift
//  White Mountain Four Thousand Footers
//
//  Created by Nathan Beaumont on 11/28/20.
//

import CoreData
import Foundation
import Metal

class MountainBagCoreData: NSManagedObject {
    @NSManaged var mountainId: Int

    enum CodingKeys: String, CodingKey {
        case mountainId = "mountain_id"
    }

    convenience required init(mountainId: Int, insertInto context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: AppConstants.Database.MountainBagEntity, in: context)!
        self.init(entity: entity, insertInto: context)
        self.mountainId = mountainId
    }
}

struct MountainBag: Codable {
    var mountainId: Int

    enum CodingKeys: String, CodingKey {
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
