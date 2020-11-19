//
//  ViewRouter.swift
//  White Mountain Four Thousand Footers
//
//  Created by Nathan Beaumont on 11/15/20.
//

import SwiftUI

enum RegistrationPage {
    case landingScreen
    case registrationScreen
    case signInScreen
}

class ViewRouter: ObservableObject {

    @Published var currentPage: RegistrationPage = .landingScreen

}
