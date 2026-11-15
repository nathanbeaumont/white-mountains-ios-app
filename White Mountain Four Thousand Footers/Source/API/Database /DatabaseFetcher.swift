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

    /// Returns the stored peaks, seeding Core Data from the bundled `mountain_peaks.json`
    /// on first launch or whenever the stored list differs in size from the bundled one.
    /// Must be called on the main thread (uses the view context).
    public func fetchOrSeedMountainPeaks() -> [MountainPeak] {
        let context = PersistenceController.shared.container.viewContext

        guard let url = Bundle.main.url(forResource: "mountain_peaks", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let bundledPeaks = (try? JSONSerialization.jsonObject(with: data)) as? [Any] else {
            print("mountain_peaks.json is missing or invalid")
            return fetchMountainPeaks() ?? []
        }

        let storedPeaks = fetchMountainPeaks()
        if let storedPeaks, storedPeaks.count == bundledPeaks.count {
            return storedPeaks
        }

        storedPeaks?.forEach { context.delete($0) }

        let decoder = JSONDecoder()
        decoder.userInfo[.managedObjectContext] = context
        do {
            let peaks = try decoder.decode([MountainPeak].self, from: data)
            PersistenceController.shared.save()
            return peaks
        } catch {
            print("Failed to seed mountain peaks: \(error)")
            context.rollback()
            return []
        }
    }
}
