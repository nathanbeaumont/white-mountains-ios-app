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
        VStack(alignment: .leading) {
            Text(mountainPeak.name)
                .font(Font.avenirMedium(withSize: 25.0))
                .fontWeight(.bold)
                .lineLimit(2)
            Text("Elevation: \(mountainPeak.elevation) ft")
                .font(Font.avenirMedium(withSize: 14.0))
            Text("Ascent: \(mountainPeak.ascent) ft")
                .font(Font.avenirMedium(withSize: 14.0))
            Spacer()
        }
    }
}

struct MountainPeakCell_Previews: PreviewProvider {
    static var previews: some View {
        MountainPeakCell(mountainPeak: MountainPeak.Fixture.mountWashingtonPeak())
    }
}
