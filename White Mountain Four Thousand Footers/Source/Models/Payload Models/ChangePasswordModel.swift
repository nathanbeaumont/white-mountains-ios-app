//
//  ChangePassword.swift
//  White Mountain Four Thousand Footers
//
//  Created by Nathan Beaumont on 02/07/21.
//

import Foundation

struct ChangePasswordModel: Codable {
    let email: String
    let resetToken: UUID
    let newPassword: String

    enum CodingKeys: String, CodingKey {
        case email
        case resetToken = "password_reset_token"
        case newPassword = "password"
    }

    init?(newPassword: String) {
        guard let initiateChangePasswordModel = KeyChain.shared.mostRecentPasswordResetToken else {
            return nil
        }

        email = initiateChangePasswordModel.email
        resetToken = initiateChangePasswordModel.resetToken
        self.newPassword = newPassword
    }

    public func validateInformation(repeatedPassword: String) -> RegisterInfo.ValidationStatus {
        if !email.isValidEmail() {
            return .emailInvalid
        } else if !(newPassword.isPasswordComplex()) {
            return .passwordComplexity
        } else if !(newPassword == repeatedPassword) {
            return .passwordsDoNotMatch
        }

        return .valid
    }
}
