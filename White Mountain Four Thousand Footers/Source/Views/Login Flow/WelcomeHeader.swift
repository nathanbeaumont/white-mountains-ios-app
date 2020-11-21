//
//  WelcomeHeader.swift
//  White Mountain Four Thousand Footers
//
//  Created by Nathan Beaumont on 11/18/20.
//

import SwiftUI

struct WelcomeHeader: View {

    let fontSize: CGFloat
    let title: String

    init(fontSize: CGFloat = 72.0, title: String) {
        self.fontSize = fontSize
        self.title = title
    }

    var body: some View {
        ZStack {
            Rectangle()
                .background(Color.white)
                .opacity(0.4)
            Text(title)
                .font(Font.avenirMedium(withSize: fontSize))
                .multilineTextAlignment(.center)
                .padding()
                .foregroundColor(.white)
                .layoutPriority(1)
        }
        .cornerRadius(15.0)
    }
}
struct WelcomeHeader_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeHeader(title: "Welcome back")
    }
}
