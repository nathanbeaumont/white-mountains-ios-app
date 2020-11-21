//
//  SignInInfo.swift
//  White Mountain Four Thousand Footers
//
//  Created by Nathan Beaumont on 11/21/20.
//

import Foundation

struct SignInInfo: Codable {
    let email: String
    let password: String

    enum CodingKeys: String, CodingKey {
        case email
        case password
    }

    init?(email: String, password: String) {
        guard email.isValidEmail(), password.count > 8 else {
            return nil
        }

        self.email = email
        self.password = password
    }
}
