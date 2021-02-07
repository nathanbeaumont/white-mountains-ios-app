//
//  MountainPeak.swift
//  White Mountain Four Thousand Footers
//
//  Created by Nathan Beaumont on 11/1/20.
//

import Foundation

struct PasswordReset: Codable {
    let email: String
    let resetToken: UUID

    enum CodingKeys: String, CodingKey {
        case email
        case resetToken = "password_reset_token"
    }

    init(emailAddress: String) {
        email = emailAddress
        resetToken = UUID()
    }
}
