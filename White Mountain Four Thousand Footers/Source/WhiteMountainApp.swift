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

    let apiRquestStatusChangePublisher = NotificationCenter.default.publisher(for: NSNotification.Name.APIRequestStatusChange)
    @State private var performingRequest = false
    @State private var timerDelay: Timer?

    var body: some Scene {
        WindowGroup {
            ZStack {
                HomeView()
                    .onReceive(apiRquestStatusChangePublisher, perform: { _ in
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

                if performingRequest && timerDelay == nil {
                    Spinner(isAnimating: performingRequest)
                }
            }
        }
    }
}
