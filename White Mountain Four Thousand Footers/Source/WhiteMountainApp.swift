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
            VStack {
                switch viewRouter.currentState {
                    case .registration:
                        SignInLandingView()
                            .preferredColorScheme(.light)
                            .environmentObject(viewRouter)
                    case .authenticated:
                        HomeView()
                            .environmentObject(viewRouter)
                    case .changePassword:
                        ChangePassword()
                            .environmentObject(viewRouter)
                }
            }.onOpenURL(perform: { url in
                if let scheme = url.scheme,
                        scheme.localizedCaseInsensitiveCompare("com.White-Mountain-Four-Thousand-Footers") == .orderedSame,
                        let _ = url.host {
                            var parameters: [String: String] = [:]
                            URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems?.forEach {
                                parameters[$0.name] = $0.value
                            }

                        if PasswordReset.validation(params: parameters) {
                            viewRouter.currentState = .changePassword
                        }
                    }
            })
        }
    }
}
