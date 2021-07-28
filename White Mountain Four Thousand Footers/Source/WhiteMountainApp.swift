//
//  White_Mountain_Four_Thousand_FootersApp.swift
//  White Mountain Four Thousand Footers
//
//  Created by Nathan Beaumont on 10/29/20.
//

import SwiftUI
import Combine

@main
struct WhiteMountainApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    @StateObject var viewRouter = ViewRouter()
    @State private var showingAlert = false

    let publisher = NotificationCenter.default.publisher(for: NSNotification.Name.APIRequestStatusChange)
    @State private var performingRequest = false
    @State private var timerDelay: Timer?

    var body: some Scene {
        WindowGroup {
            ZStack {
                VStack {
                    switch viewRouter.currentState {
                        case .registration:
                            SignInLandingView()
                                .preferredColorScheme(.light)
                                .environmentObject(viewRouter)
                                .alert(isPresented: $showingAlert, content: {
                                    Alert(title: Text("Expired Link"),
                                          message: Text("Sorry, that password reset link has expired. Please request a new one."),
                                          dismissButton: .default(Text("Okay")))
                                })
                        case .authenticated:
                            HomeView()
                                .environmentObject(viewRouter)
                        case .changePassword:
                            ChangePassword()
                                .environmentObject(viewRouter)
                    }
                }
                .onOpenURL(perform: { url in
                    if let scheme = url.scheme,
                            scheme.localizedCaseInsensitiveCompare("com.White-Mountain-Four-Thousand-Footers") == .orderedSame,
                            let _ = url.host {
                                var parameters: [String: String] = [:]
                                URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems?.forEach {
                                    parameters[$0.name] = $0.value
                                }

                            if PasswordReset.validation(params: parameters) {
                                viewRouter.currentState = .changePassword
                            } else {
                                showingAlert = true
                            }
                        }
                })
                .onReceive(publisher, perform: { _ in
                    if APIClient.shared.performingRequest {
                        self.timerDelay = Timer.scheduledTimer(withTimeInterval: 1.2, repeats: false) { _ in
                            self.performingRequest = APIClient.shared.performingRequest

                            self.timerDelay?.invalidate()
                            self.timerDelay = nil
                        }
                    } else {
                        self.performingRequest = false
                        self.timerDelay?.invalidate()
                        self.timerDelay = nil
                    }
                })

                 // ZStack Continued
                if performingRequest && timerDelay == nil {
                    Spinner(isAnimating: performingRequest)
                }
            }
        }
    }
}
