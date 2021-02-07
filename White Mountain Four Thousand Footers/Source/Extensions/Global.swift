//
//  View.swift
//  White Mountain Four Thousand Footers
//
//  Created by Nathan Beaumont on 2/7/21.
//

import SwiftUI

#if canImport(UIKit)
func hideKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
}
#endif
