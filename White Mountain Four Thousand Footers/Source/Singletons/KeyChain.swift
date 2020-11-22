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
    var userAccessToken: String? {
        get {
            return keyChain[UserAccessTokenKey]
        }
        set {
            keyChain[UserAccessTokenKey] = newValue
        }
    }
}
