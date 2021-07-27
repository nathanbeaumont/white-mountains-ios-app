//
//  String.swift
//  White Mountain Four Thousand Footers
//
//  Created by Nathan Beaumont on 11/15/20.
//

import Foundation

extension String {
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }

    func isPasswordComplex() -> Bool {
        let passwordComplexity = "^(?=.*[0-9]).{8,}$"

        let passwordPred = NSPredicate(format:"SELF MATCHES %@", passwordComplexity)
        return passwordPred.evaluate(with: self)
    }
}
