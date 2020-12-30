//
//  MountainDataSource.swift
//  White Mountain Four Thousand Footers
//
//  Created by Nathan Beaumont on 12/30/20.
//

import Combine
import SwiftUI

class MountainDataSource: ObservableObject {

    // Need to add this as, there is currenlty a bug with ObservalbeObject
    let objectWillChange = ObservableObjectPublisher()

    @Published var mountainPeaks = [MountainPeak]()
    @Published var mountainPeaksHiked = Array<MountainBag>()

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

    func loadMountainPeaks() {
        let apiRequest =  APIRequestFactory.mountainPeaks()
        APIClient.shared.perform(request: apiRequest) { mountainPeaks in
            self.mountainPeaks = mountainPeaks
            self.updateSorting(filter: .elevationDescending)
            self.getPeaksBagged()
        }
    }

    func getPeaksBagged() {
        let apiRequest =  APIRequestFactory.mountainsPeaksBagged()
        APIClient.shared.perform(request: apiRequest) { peaks in
            self.objectWillChange.send()
            self.mountainPeaksHiked = peaks
        }
    }
}

class MapMountainDataSource: MountainDataSource {
    private var _mapAnnotations = [MountainPeakAnnotation]()

    var mapAnnotations: [MountainPeakAnnotation] {
        if _mapAnnotations.isEmpty {
            _mapAnnotations = mountainPeaks.map { peak -> MountainPeakAnnotation in
                return MountainPeakAnnotation(name: peak.name,
                                              latitude: peak.latitude,
                                              longitude: peak.longitude,
                                              peakHiked: mountainPeaksHiked.peakHiked(peak.id))
            }
        }

        return _mapAnnotations
    }
}
