//
//  MountainDataSource.swift
//  White Mountain Four Thousand Footers
//
//  Created by Nathan Beaumont on 12/30/20.
//

import Alamofire
import Combine
import CoreData
import Firebase
import SwiftUI

final class MountainDataSource: ObservableObject {

    static let shared = MountainDataSource()

    private init() {}

    // Need to add this as, there is currenlty a bug with ObservalbeObject
    let objectWillChange = ObservableObjectPublisher()

    @Published var mountainPeaks = [MountainPeak]()
    @Published var mountainBags = [MountainBag]()

    func updateSorting(filter: ListFilterView.ListFilterState) {
        switch filter {
            case .elevationDescending:
                mountainPeaks.sort {  $0.elevation > $1.elevation }
            case .elevationAscending:
                mountainPeaks.sort {  $0.elevation < $1.elevation }
            case .alphabeticalAZ:
                mountainPeaks.sort {  $0.name < $1.name }
            case .alphabeticalZA:
                mountainPeaks.sort {  $0.name > $1.name }
        }
    }

    // MARK: Mountain Peaks

    func loadMountainPeaks() {
        // Current app session, moutains already loaded return early
        guard self.mountainPeaks.isEmpty else {
            mountainPeakUpdate()
            return
        }

        // Query for mountains from DB and make background request to update DB
        if let mountainPeaks = DataBaseFetcher.shared.fetchMountainPeaks() {
            self.mountainPeaks = mountainPeaks
            mountainPeakUpdate()

            // Perform background request to cache updated list of mountains
            // Server will be source of truth
            APIClient.shared.performBackgroundRequest(request: APIRequestFactory.mountainPeaks(),
                                                      success: { _ in
                self.clearMountainPeaks()
                let managedObjectContext = PersistenceController.shared.container.viewContext
                APIClient.shared.saveContext(managedObjectContext: managedObjectContext)
            }, failure: nil)
        } else {
            // First time user make API Request and cache results
            let apiRequest =  APIRequestFactory.mountainPeaks()
            APIClient.shared.perform(request: apiRequest) { mountainPeaks in
                // Save list to DB
                let managedObjectContext = PersistenceController.shared.container.viewContext
                APIClient.shared.saveContext(managedObjectContext: managedObjectContext)

                self.mountainPeaks = mountainPeaks
                self.mountainPeakUpdate()
            }
        }
    }

    private func mountainPeakUpdate() {
        self.updateSorting(filter: .elevationDescending)
        self.getPeaksBagged()
    }

    // MARK: Peak Bagging

    func bagNewPeak(mountainId: Int, successClosure: () -> Void) {
        let managedContext = PersistenceController.shared.container.viewContext
        let bag = MountainBagCoreData(mountainId: mountainId, insertInto: managedContext)
        managedContext.insert(bag)
        APIClient.shared.saveContext(managedObjectContext: managedContext)
        successClosure()
        self.objectWillChange.send()
        self.mountainBags.append(MountainBag(mountainId: mountainId))

        let apiRequest = APIRequestFactory.bagMountainPeak(mountainId: mountainId)
        APIClient.shared.performBackgroundRequest(request: apiRequest) { _ in
            Analytics.logEvent("Peak_Bagged", parameters: ["peak_id": mountainId])
        }
    }

    func removePeak(mountainId: Int, successClosure: () -> Void) {
        let managedContext = PersistenceController.shared.container.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: AppConstants.Database.MountainBagEntity)
        do {
            let bags = try managedContext.fetch(fetchRequest)
            bags.forEach {
                if let bag = $0 as? MountainBagCoreData, bag.mountainId == mountainId {
                    managedContext.delete(bag)
                }
            }
            APIClient.shared.saveContext(managedObjectContext: managedContext)
            self.objectWillChange.send()
            self.mountainBags = self.mountainBags.filter({ $0.mountainId != mountainId })

            successClosure()
        } catch let error as NSError {
            print("Could not find mountain bag to delete. \(error), \(error.userInfo)")
        }

        let apiRequest = APIRequestFactory.removeMountainBag(mountainId: mountainId)
        APIClient.shared.performBackgroundRequest(request: apiRequest, success: nil)
    }

    func getPeaksBagged() {
        if let mountainBags = DataBaseFetcher.shared.fetchMountainBags() {
            // Perform background request to cache updated list of mountains
            APIClient.shared.performBackgroundRequest(request: APIRequestFactory.mountainsPeaksBagged(),
                                                      success: { severMountainBags in

                // Mountains Peaks to Add to Server
                let peaksToAdd = mountainBags
                    .filter { dataBasePeak in
                        !severMountainBags.contains { serverPeak in
                            serverPeak.mountainId == serverPeak.mountainId
                        }
                    }
                print(peaksToAdd)
                peaksToAdd
                    .map { APIRequestFactory.bagMountainPeak(mountainId: $0.mountainId) }
                    .forEach { request in
                        APIClient.shared.performBackgroundRequest(request: request,
                                                                  success: { _ in  },
                                                                  failure: { _,_ in })
                    }
            }, failure: nil)

            self.objectWillChange.send()
            self.mountainBags = mountainBags.map { MountainBag(mountainId: $0.mountainId) }
        } else {
            // First time login
            let apiRequest =  APIRequestFactory.mountainsPeaksBagged()
            APIClient.shared.perform(request: apiRequest) { bags in
                // Save list to DB
                let managedObjectContext = PersistenceController.shared.container.viewContext
                bags
                    .map { MountainBagCoreData(mountainId: $0.mountainId, insertInto: managedObjectContext) }
                    .forEach { dataEntity in
                        managedObjectContext.insert(dataEntity)
                    }

                APIClient.shared.saveContext(managedObjectContext: managedObjectContext)
                self.objectWillChange.send()
                self.mountainBags = bags
            }
        }
    }

    func clearDataSource() {
        self.objectWillChange.send()
        self.clearMountainBags()
        self.clearMountainPeaks()
        self.mountainPeaks = []
    }

    //MARK:  Map MountainDataSource Support
    @Published var mapAnnotations = [MountainPeakAnnotation]()

    func generateMapAnnotations() {
        mapAnnotations = mountainPeaks.map { peak -> MountainPeakAnnotation in
            return MountainPeakAnnotation(name: peak.name,
                                          latitude: peak.latitude,
                                          longitude: peak.longitude,
                                          peakHiked: mountainBags.peakHiked(peak.id))
        }
    }

    // MARK: Private Methods

    func clearMountainPeaks() {
        let managedObjectContext = PersistenceController.shared.container.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: AppConstants.Database.MountainPeakEntity)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try managedObjectContext.execute(batchDeleteRequest)
        } catch let error as NSError {
            print(error)
        }
    }

    func clearMountainBags() {
        let managedObjectContext = PersistenceController.shared.container.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: AppConstants.Database.MountainBagEntity)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try managedObjectContext.execute(batchDeleteRequest)
        } catch let error as NSError {
            print(error)
        }
    }
}
