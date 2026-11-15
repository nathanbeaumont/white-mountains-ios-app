//
//  MountainPeakCell.swift
//  White Mountain Four Thousand Footers
//
//  Created by Nathan Beaumont on 11/6/20.
//

import SwiftUI
import UIKit
import FirebaseAnalytics

struct MountainPeakCell: View {

    let mountainPeak: MountainPeak
    let peakHiked: Bool
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

            Button(action: togglePeakHiked, label: {
                // Both icons stay in the hierarchy and cross-fade, so the animation survives
                // the list re-rendering the row when the data source updates.
                ZStack {
                    Image(systemName: "plus.circle")
                        .font(.system(size: 25))
                        .opacity(peakHiked ? 0 : 1)

                    Image(systemName: "checkmark.circle")
                        .renderingMode(.template)
                        .foregroundColor(Color.Custom.darkBackgroundGreen)
                        .font(.system(size: 44))
                        .opacity(peakHiked ? 1 : 0)
                        .scaleEffect(peakHiked ? 1 : 0.7)
                }
                .frame(width: 44, height: 44)
                .animation(.easeInOut(duration: 0.5), value: peakHiked)
            })
            .buttonStyle(PlainButtonStyle())
        }
        .padding(10)
        .background(currentMode == .dark ?  Color.black : Color.white)
        .listRowBackground(Color.clear)
        .listRowInsets(EdgeInsets(top: 11.25, leading: 16, bottom: 11.25, trailing: 16))
        .cornerRadius(10.0)
        .sheet(isPresented: $isPresented) {
            WebView(url: mountainPeak.urls.first!)
        }
    }

    private func togglePeakHiked() {
        if peakHiked {
            MountainDataSource.shared.removePeak(mountainId: mountainPeak.id)
        } else {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            MountainDataSource.shared.bagNewPeak(mountainId: mountainPeak.id)
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
        .preferredColorScheme(.dark)
    }
}
