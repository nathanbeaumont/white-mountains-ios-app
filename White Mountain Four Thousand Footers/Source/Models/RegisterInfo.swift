//
//  RegisterInfo.swift
//  White Mountain Four Thousand Footers
//
//  Created by Nathan Beaumont on 11/15/20.
//

import Foundation

struct RegisterInfo: Codable {

    let email: String
    let name: String
    let password: String

    enum CodingKeys: String, CodingKey {
        case email
        case name = "displayName"
        case password
    }

    init?(email: String, name: String, password: String) {
        guard email.isValidEmail(), name.count > 2, password.count > 8 else {
            return nil
        }

        self.email = email
        self.name = name
        self.password = password
    }
}
