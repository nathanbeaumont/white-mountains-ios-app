//
//  PeakMap.swift
//  White Mountain Four Thousand Footers
//
//  Created by Nathan Beaumont on 12/19/20.
//

import MapKit
import SwiftUI
import Combine

struct MountainPeakAnnotation: Identifiable {
    /// The mountain peak's id, so annotations keep a stable identity across refreshes.
    let id: Int
    let latitude: Double
    let longitude: Double

    var coordinate: CLLocationCoordinate2D {
      CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}


struct PeakMap: View {

    static private let mapCenter = CLLocationCoordinate2D(latitude: 44.146, longitude: -71.317)
    static private let mapSpan = MKCoordinateSpan(latitudeDelta: 1.25, longitudeDelta: 1.25)

    @State private var region = MKCoordinateRegion(center: PeakMap.mapCenter, span: PeakMap.mapSpan)
    @State private var selectedPeakId: Int?
    @ObservedObject private var mountainDataSource = MountainDataSource.shared

    private var selectedPeak: MountainPeak? {
        guard let selectedPeakId else { return nil }
        return mountainDataSource.mountainPeaks.first { $0.id == selectedPeakId }
    }

    var body: some View {
        Map(coordinateRegion: $region, annotationItems: mountainDataSource.mapAnnotations) { annotation in
            MapAnnotation(coordinate: annotation.coordinate, anchorPoint: CGPoint(x: 0.5, y: 0.5)) {
                MountainAnnotation(peakHiked: mountainDataSource.mountainBags.peakHiked(annotation.id),
                                   isSelected: selectedPeakId == annotation.id,
                                   action: { toggleSelection(of: annotation.id) })
            }
        }
        .ignoresSafeArea()
        .overlay(alignment: .bottom) {
            if let peak = selectedPeak {
                PeakDetailCard(peak: peak,
                               peakHiked: mountainDataSource.mountainBags.peakHiked(peak.id),
                               onDismiss: { toggleSelection(of: peak.id) })
                    .padding(.horizontal, 16)
                    .padding(.bottom, 8)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .onAppear(perform: {
            mountainDataSource.loadMountainPeaks()
            mountainDataSource.generateMapAnnotations()
        })
    }

    private func toggleSelection(of peakId: Int) {
        withAnimation(.easeInOut(duration: 0.25)) {
            selectedPeakId = (selectedPeakId == peakId) ? nil : peakId
        }
    }
}

/// The same row used on the peak list, shown over the map. Swipe it down to dismiss.
private struct PeakDetailCard: View {

    let peak: MountainPeak
    let peakHiked: Bool
    let onDismiss: () -> Void

    @State private var dragOffset: CGFloat = 0

    var body: some View {
        MountainPeakCell(mountainPeak: peak, peakHiked: peakHiked)
            .shadow(color: Color.black.opacity(0.25), radius: 8, x: 0, y: 2)
            .offset(y: dragOffset)
            .opacity(1.0 - min(Double(dragOffset) / 300.0, 0.4))
            .gesture(
                DragGesture(minimumDistance: 10)
                    .onChanged { value in
                        // Only follow downward drags.
                        dragOffset = max(0, value.translation.height)
                    }
                    .onEnded { value in
                        if value.translation.height > 60 || value.predictedEndTranslation.height > 140 {
                            onDismiss()
                        } else {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                dragOffset = 0
                            }
                        }
                    }
            )
    }
}

struct MountainAnnotation: View {

    let peakHiked: Bool
    let isSelected: Bool
    let action: () -> Void

    private var imageName: String {
        switch (peakHiked, isSelected) {
            case (false, false): return "Mountain_Peak"
            case (true, false): return "Mountain_Peak_Hiked"
            case (false, true): return "Mountain_Peak_Selected"
            case (true, true): return "Mountain_Peak_Hiked_Selected"
        }
    }

    // Hiked and selected icons are taller (flag / magnifying glass above the mountain).
    private var isTall: Bool { peakHiked || isSelected }

    var body: some View {
        Button(action: action, label: {
            Image(imageName)
                .resizable()
                .frame(width: 28, height: isTall ? 32 : 17)
                // Scale around the mountain (not the whole image) so it grows in place.
                .scaleEffect(isSelected ? 1.35 : 1.0, anchor: isTall ? UnitPoint(x: 0.5, y: 0.73) : .center)
                // The mountain sits in the lower part of tall icons; shift up so it stays on its coordinate.
                .offset(y: isTall ? -7.3 : 0)
                .animation(.easeInOut(duration: 0.2), value: isSelected)
        })
    }
}
