//
//  MountainPeakCell.swift
//  White Mountain Four Thousand Footers
//
//  Created by Nathan Beaumont on 11/6/20.
//

import SwiftUI

struct MountainPeakCell: View {

    let mountainPeak: MountainPeak
    let peakHiked: Bool

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(mountainPeak.name)
                    .font(Font.avenirMedium(withSize: 25.0))
                    .fontWeight(.bold)
                    .lineLimit(2)
                Text("Elevation: \(mountainPeak.elevation) ft")
                    .font(Font.avenirMedium(withSize: 14.0))
                Text("Ascent: \(mountainPeak.ascent) ft")
                    .font(Font.avenirMedium(withSize: 14.0))
            }
            Spacer()
            if peakHiked {
                Image(systemName: "checkmark.circle")
                    .renderingMode(/*@START_MENU_TOKEN@*/.template/*@END_MENU_TOKEN@*/)
                    .foregroundColor(Color.Custom.darkBackgroundGreen)
                    .font(.system(size: 44))
            }
        }
        .padding(10)
        .background(Color.white)
        .listRowBackground(Color.white)
        .cornerRadius(10.0)
    }
}

struct MountainPeakCell_Previews: PreviewProvider {
    static var previews: some View {
        List {
            MountainPeakCell(mountainPeak: MountainPeak.Fixture.mountWashingtonPeak(),
                             peakHiked: true)
            MountainPeakCell(mountainPeak: MountainPeak.Fixture.mountWashingtonPeak(),
                             peakHiked: false)

        }.background(Color.pink)
    }
}
