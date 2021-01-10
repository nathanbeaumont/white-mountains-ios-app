//
//  SettingsCell.swift
//  White Mountain Four Thousand Footers
//
//  Created by Nathan Beaumont on 1/10/21.
//

import Foundation
import SwiftUI

struct SettingsCell: View {    
    var title: String
    var action: (() -> Void)?

    var body: some View {
        HStack {
            Text(title)
                .font(Font.avenirMedium(withSize: 17.0))
            Spacer()
            Image(systemName: "arrowtriangle.backward")
                .rotationEffect(Angle(degrees: 180.0))
        }
        .contentShape(Rectangle())
        .onTapGesture {
            action?()
        }
    }
}
