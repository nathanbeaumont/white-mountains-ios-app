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
}

extension RegisterInfo {

    enum ValidationStatus: String {
        case valid = ""
        case nameLength = "Please enter a display name."
        case emailInvalid = "Email entered is not valid"
        case passwordComplexity = "Please make sure you password is 8 characters in length and contains 1 number"
        case passwordsDoNotMatch = "Passwords do not match!"
    }

    public func validateInformation(repeatedPassword: String) -> ValidationStatus {
        if name.count <= 2 {
            return .nameLength
        } else if !email.isValidEmail() {
            return .emailInvalid
        } else if !(password.isPasswordComplex()) {
            return .passwordComplexity
        } else if !(password == repeatedPassword) {
            return .passwordsDoNotMatch
        }

        return .valid
    }
}
