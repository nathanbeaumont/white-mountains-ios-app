//
//  MountainDataSource.swift
//  White Mountain Four Thousand Footers
//
//  Created by Nathan Beaumont on 12/30/20.
//

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
        if mountainPeaks.isEmpty {
            mountainPeaks = DataBaseFetcher.shared.fetchOrSeedMountainPeaks()
        }
        mountainPeakUpdate()
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
        PersistenceController.shared.save()
        successClosure()
        self.objectWillChange.send()
        self.mountainBags.append(MountainBag(mountainId: mountainId))

        Analytics.logEvent("Peak_Bagged", parameters: ["peak_id": mountainId])
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
            PersistenceController.shared.save()
            self.objectWillChange.send()
            self.mountainBags = self.mountainBags.filter({ $0.mountainId != mountainId })

            successClosure()
        } catch let error as NSError {
            print("Could not find mountain bag to delete. \(error), \(error.userInfo)")
        }
    }

    func getPeaksBagged() {
        let storedBags = DataBaseFetcher.shared.fetchMountainBags() ?? []
        self.objectWillChange.send()
        self.mountainBags = storedBags.map { MountainBag(mountainId: $0.mountainId) }
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
}
