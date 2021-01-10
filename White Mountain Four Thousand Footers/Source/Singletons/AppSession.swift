//
//  AppSession.swift
//  White Mountain Four Thousand Footers
//
//  Created by Nathan Beaumont on 11/21/20.
//

import Foundation

final class AppSession {
    static let shared = AppSession()

    private init() {}

    public var userAuthenticated: Bool {
        return !(KeyChain.shared.userAccessToken == nil)
    }

    public func removeAuthentication() {
        KeyChain.shared.userAccessToken = nil
    }
}
