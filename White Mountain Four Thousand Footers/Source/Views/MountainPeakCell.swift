//
//  MountainPeakCell.swift
//  White Mountain Four Thousand Footers
//
//  Created by Nathan Beaumont on 11/6/20.
//

import SwiftUI

struct MountainPeakCell: View {

    let mountainPeak: MountainPeak

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
            MountainPeakCell(mountainPeak: MountainPeak.Fixture.mountWashingtonPeak())

        }.background(Color.pink)
    }
}
