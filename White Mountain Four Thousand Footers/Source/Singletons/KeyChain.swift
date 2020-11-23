//
//  KeyChain.swift
//  White Mountain Four Thousand Footers
//
//  Created by Nathan Beaumont on 11/21/20.
//

import Foundation
import KeychainAccess

final class KeyChain {
    static let shared = KeyChain()

    let keyChain: KeychainAccess.Keychain = Keychain(service: "com.nathan-beaumont.White-Mountain-Four-Thousand-Footers")

    let UserAccessTokenKey = "UserAccessTokenKey"
    private var _userAccessToken: String?
    var userAccessToken: String? {
        get {
            if _userAccessToken == nil {
                return keyChain[UserAccessTokenKey]
            }

            return _userAccessToken
        }
        set {
            _userAccessToken = newValue
            keyChain[UserAccessTokenKey] = newValue
        }
    }
}
