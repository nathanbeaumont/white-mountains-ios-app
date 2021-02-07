//
//  ViewRouter.swift
//  White Mountain Four Thousand Footers
//
//  Created by Nathan Beaumont on 11/15/20.
//

import SwiftUI

enum ApplicationState {
    case registration
    case authenticated
    case changePassword
}

class ViewRouter: ObservableObject {

    @Published var currentState: ApplicationState

    init() {
        let userLoggedIn = AppSession.shared.userAuthenticated
        currentState = userLoggedIn ? .authenticated : .registration
    }
}
