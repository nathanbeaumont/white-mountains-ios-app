//
//  ActivityIndicator.swift
//  White Mountain Four Thousand Footers
//
//  Created by Nathan Beaumont on 2/28/21.
//

import Foundation
import SwiftUI
import ActivityIndicatorView

struct Spinner: View {

    @State var isAnimating: Bool = true

    var body: some View {
        VStack {
            if isAnimating {
                ZStack(alignment: .center) {
                    Rectangle()
                        .frame(width: 75, height: 75, alignment: .center)
                        .foregroundColor(Color.Custom.backgroundGreen)
                        .cornerRadius(15.0)
                    ActivityIndicatorView(isVisible: $isAnimating, type: .default())
                        .foregroundColor(Color.Custom.darkBackgroundGreen)
                        .background(Color.clear)
                        .frame(width: 50, height: 50, alignment: .center)
                        .cornerRadius(8)
                }
            }
        }
    }
}

struct Spinner_Previews: PreviewProvider {
    static var previews: some View {
        Spinner(isAnimating: true)
    }
}
