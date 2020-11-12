//
//  Color.swift
//  White Mountain Four Thousand Footers
//
//  Created by Nathan Beaumont on 11/6/20.
//

import SwiftUI
import Foundation

extension Color {

    static func colorWithRed(_ red: Int, green: Int, blue: Int) -> Color {
        let redScale = CGFloat(red) / 255.0
        let greenScale = CGFloat(green) / 255.0
        let blueScale = CGFloat(blue) / 255.0

        let color = UIColor(red: redScale, green: greenScale,
                            blue: blueScale, alpha: 1.0)
        return Color(color)
    }

    struct Custom {
        static var backgroundGreen: Color {
            return Color.colorWithRed(140, green: 179, blue: 105)
        }

        static var darkBackgroundGreen: Color {
            return Color.colorWithRed(91, green: 118, blue: 70)
        }
    }
}

struct Color_Previews: PreviewProvider {
    static var previews: some View {
        Color.Custom.darkBackgroundGreen
    }
}
