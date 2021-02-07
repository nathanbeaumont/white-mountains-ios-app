//
//  PasswordReset.swift
//  White Mountain Four Thousand Footers
//
//  Created by Nathan Beaumont on 02/8/21.
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

    private init(emailAddress: String, resetToken: UUID) {
        email = emailAddress
        self.resetToken = resetToken
    }

    static func validation(params: [String: String]) -> Bool {
        guard let email = params[CodingKeys.email.stringValue],
              let resetToken = params[CodingKeys.resetToken.stringValue],
              let uuid = UUID(uuidString: resetToken) else {
            return false
        }

        guard uuid == KeyChain.shared.mostRecentPasswordResetToken?.resetToken,
              email == KeyChain.shared.mostRecentPasswordResetToken?.email else {
            return false
        }

        return true
    }
}
