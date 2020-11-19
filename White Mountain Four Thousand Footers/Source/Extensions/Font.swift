//
//  Font.swift
//  White Mountain Four Thousand Footers
//
//  Created by Nathan Beaumont on 11/6/20.
//

import Foundation
import SwiftUI

extension Font {
    static func avenirMedium(withSize size: CGFloat) -> Font {
        return Font.custom("Avenir-Medium", size: size)
    }

    static func avenirHeavy(withSize size: CGFloat) -> Font {
        return Font.custom("Avenir-Heavy", size: size)
    }
}
