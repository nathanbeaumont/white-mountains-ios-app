//
//  DatabaseManager.swift
//  White Mountain Four Thousand Footers
//
//  Created by Nathan Beaumont on 9/29/21.
//

import CoreData
import Foundation
import UIKit

extension CodingUserInfoKey {
  static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
}

enum DecoderConfigurationError: Error {
  case missingManagedObjectContext
}

final class DataBaseFetcher {
    static let shared = DataBaseFetcher()
    private init() { }

    public func fetchMountainPeaks() -> [MountainPeak]? {
        let managedObjectContext = PersistenceController.shared.container.viewContext
        let fetchRequest = NSFetchRequest<MountainPeak>(entityName: AppConstants.Database.MountainPeakEntity)
        do {
            let mountains = try managedObjectContext.fetch(fetchRequest)
            guard !mountains.isEmpty else { return nil }
            return mountains
        } catch let error {
            print(error)
            return nil
        }
    }

    public func fetchMountainBags() -> [MountainBagCoreData]? {
        let managedObjectContext = PersistenceController.shared.container.viewContext
        let fetchRequest = NSFetchRequest<MountainBagCoreData>(entityName: AppConstants.Database.MountainBagEntity)
        do {
            let bags = try managedObjectContext.fetch(fetchRequest)
            guard !bags.isEmpty else { return nil }
            return bags
        } catch let error {
            print(error)
            return nil
        }
    }
}
