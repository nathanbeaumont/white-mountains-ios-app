//
//  NavigationBackButton.swift
//  White Mountain Four Thousand Footers
//
//  Created by Nathan Beaumont on 11/17/20.
//

import SwiftUI

struct NavigationBackButton: View {

    let buttonAction: () -> Void
    let fontSize: CGFloat = 23.0

    var body: some View {
        Button(action: {
            buttonAction()
        }) {
            HStack {
                Image("Navigation_Back_Arrow")
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                Text("Back")
                    .font(Font.avenirHeavy(withSize: fontSize))
            }.foregroundColor(.white)
        }

    }
}

struct NavigationBackButton_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBackButton(buttonAction: {}).background(Color.purple)
    }
}
