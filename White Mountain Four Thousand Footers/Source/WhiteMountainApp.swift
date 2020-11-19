//
//  White_Mountain_Four_Thousand_FootersApp.swift
//  White Mountain Four Thousand Footers
//
//  Created by Nathan Beaumont on 10/29/20.
//

import SwiftUI

@main
struct WhiteMountainApp: App {

    @StateObject var viewRouter = ViewRouter()

    var body: some Scene {
        WindowGroup {
            switch viewRouter.currentPage {
                case .landingScreen:
                    SignInLandingView().environmentObject(viewRouter)
                case .registrationScreen:
                    RegisterView().environmentObject(viewRouter)
                case .signInScreen:
                    RegisterView().environmentObject(viewRouter)
            }

        }
    }
}
