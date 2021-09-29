//
//  PersistanceCordinator.swift
//  White Mountain Four Thousand Footers
//
//  Created by Nathan Beaumont on 9/29/21.
//

import CoreData
import Foundation

final class PersistenceController {

    static let shared = PersistenceController()
    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores { [weak self] description, error in
            if let error = error {
                fatalError("Error: \(error.localizedDescription)")
            }

            self?.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            self?.container.viewContext.automaticallyMergesChangesFromParent = true
        }
    }
}
