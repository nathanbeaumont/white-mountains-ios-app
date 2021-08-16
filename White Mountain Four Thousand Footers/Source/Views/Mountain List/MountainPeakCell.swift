//
//  MountainPeakCell.swift
//  White Mountain Four Thousand Footers
//
//  Created by Nathan Beaumont on 11/6/20.
//

import SwiftUI

struct MountainPeakCell: View {

    let mountainPeak: MountainPeak
    @State private(set) var peakHiked: Bool
    @State private var isPresented = false

    @Environment(\.colorScheme) var currentMode

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Text(mountainPeak.name)
                        .font(Font.avenirMedium(withSize: 25.0))
                        .fontWeight(.bold)
                        .lineLimit(2)
                    if !mountainPeak.urls.isEmpty {
                        Button(action: { self.isPresented.toggle() }, label: {
                            Image(systemName: "info.circle")
                        })
                        .buttonStyle(PlainButtonStyle())
                    }
                }

                Text("Elevation: \(mountainPeak.elevation) ft")
                    .font(Font.avenirMedium(withSize: 14.0))
                Text("Ascent: \(mountainPeak.ascent) ft")
                    .font(Font.avenirMedium(withSize: 14.0))
            }

            Spacer()
            
            if peakHiked {
                Button(action: {
                    let apiRequest = APIRequestFactory.removeMountainBag(mountainId: mountainPeak.id)
                    APIClient.shared.perform(request: apiRequest) { _ in
                        withAnimation {
                            peakHiked = false
                        }

                        NotificationCenter.default.post(Notification(name: Notification.Name.MountainPeakBagged))
                    }
                }, label: {
                    Image(systemName: "checkmark.circle")
                        .renderingMode(/*@START_MENU_TOKEN@*/.template/*@END_MENU_TOKEN@*/)
                        .foregroundColor(Color.Custom.darkBackgroundGreen)
                        .font(.system(size: 44))
                        .transition(AnyTransition.opacity.animation(.easeInOut(duration: 1.0)))
                })
                .buttonStyle(PlainButtonStyle())
            } else {
                Button(action: {
                    let apiRequest = APIRequestFactory.bagMountainPeak(mountainId: mountainPeak.id)
                    APIClient.shared.perform(request: apiRequest) { _ in
                        withAnimation {
                            peakHiked = true
                        }

                        NotificationCenter.default.post(Notification(name: Notification.Name.MountainPeakBagged))
                    }
                }, label: {
                    Image(systemName: "plus.circle")
                        .font(.system(size: 25))
                        .padding(.trailing, 11)
                })
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(10)
        .background(currentMode == .dark ?  Color.black : Color.white)
        .listRowBackground(Color.white)
        .cornerRadius(10.0)
        .sheet(isPresented: $isPresented) {
            WebView(url: mountainPeak.urls.first!)
        }
    }
}

struct MountainPeakCell_Previews: PreviewProvider {
    static var previews: some View {
        List {
            MountainPeakCell(mountainPeak: MountainPeak.Fixture.mountWashingtonPeak(),
                             peakHiked: true)
            MountainPeakCell(mountainPeak: MountainPeak.Fixture.mountWashingtonPeak(),
                             peakHiked: false)
        }
        .background(Color.pink)
        .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
    }
}
