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
    let id = UUID()
    let name: String
    let latitude: Double
    let longitude: Double
    let peakHiked: Bool
    let infoUrl: URL?

    var coordinate: CLLocationCoordinate2D {
      CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}


struct PeakMap: View {

    static private let mapCenter = CLLocationCoordinate2D(latitude: 44.146, longitude: -71.317)
    static private let mapSpan = MKCoordinateSpan(latitudeDelta: 1.25, longitudeDelta: 1.25)

    @State private var region = MKCoordinateRegion(center: PeakMap.mapCenter, span: PeakMap.mapSpan)
    @ObservedObject private var mountainDataSource = MountainDataSource.shared

    var body: some View {
        Map(coordinateRegion: $region, annotationItems: mountainDataSource.mapAnnotations) { identifier in
            MapAnnotation(coordinate: identifier.coordinate, anchorPoint: CGPoint(x: 0.5, y: 0.5)) {
                MountainAnnotation(mountainPeak: identifier)
            }
        }
        .ignoresSafeArea()
        .onAppear(perform: mountainDataSource.generateMapAnnotations)
    }
}

struct MountainAnnotation: View {

    @State private var isSelected: Bool = false
    @State private var isPresented = false

    var mountainPeakframe = CGSize(width: 28, height: 17)
    var mountainPeakHikedframe = CGSize(width: 28, height: 32)
    var mountainPeak: MountainPeakAnnotation

    var body: some View {
        ZStack {
            let imageName = mountainPeak.peakHiked ? "Mountain_Peak_Hiked" : "Mountain_Peak"
            Image(imageName)
                .resizable()
                .frame(width: mountainPeak.peakHiked ? mountainPeakHikedframe.width : mountainPeakframe.width,
                       height: mountainPeak.peakHiked ? mountainPeakHikedframe.height : mountainPeakframe.height)

            VStack {
                if isSelected {
                    HStack {
                        Text(mountainPeak.name)
                            .foregroundColor(.white)
                            .font(Font.avenirMedium(withSize: 15.0))
                            .padding()
                        if mountainPeak.infoUrl != nil {
                            Button(action: {
                                    self.isPresented.toggle()
                                print("Hellloooo from the Mountains")

                            }, label: {
                                Image(systemName: "info.circle")
                                    .padding()
                            })
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .background(Color.Custom.backgroundGreen)
                    .clipShape(Capsule())
                    .fixedSize(horizontal: true, vertical: false)
                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)

                    Spacer(minLength: 80)
                }
            }
        }
        .onTapGesture {
            isSelected = !isSelected
        }
        .sheet(isPresented: $isPresented) {
            WebView(url: mountainPeak.infoUrl!)
        }
    }
}
