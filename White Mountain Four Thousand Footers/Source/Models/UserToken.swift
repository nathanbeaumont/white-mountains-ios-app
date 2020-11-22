//
//  UserToken.swift
//  White Mountain Four Thousand Footers
//
//  Created by Nathan Beaumont on 11/21/20.
//

import Foundation

import Foundation

struct UserToken: Codable {
    let userToken: String

    enum CodingKeys: String, CodingKey {
        case userToken = "token"
    }
}

