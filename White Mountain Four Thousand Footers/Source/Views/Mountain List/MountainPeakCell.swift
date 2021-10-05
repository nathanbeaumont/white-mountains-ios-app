//
//  MountainPeakCell.swift
//  White Mountain Four Thousand Footers
//
//  Created by Nathan Beaumont on 11/6/20.
//

import SwiftUI
import FirebaseAnalytics

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
                    MountainDataSource.shared.removePeak(mountainId: mountainPeak.id) {
                        withAnimation {
                            peakHiked = false
                        }
                    }
                }, label: {
                    Image(systemName: "checkmark.circle")
                        .renderingMode(.template)
                        .foregroundColor(Color.Custom.darkBackgroundGreen)
                        .font(.system(size: 44))
                        .transition(AnyTransition.opacity.animation(.easeInOut(duration: 1.0)))
                })
                .buttonStyle(PlainButtonStyle())
            } else {
                Button(action: {
                    MountainDataSource.shared.bagNewPeak(mountainId: mountainPeak.id) {
                        withAnimation {
                            peakHiked = true
                        }
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
        .listRowBackground(Color.clear)
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
        .preferredColorScheme(.dark)
    }
}
