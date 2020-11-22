//
//  APIRequestFactory.swift
//  White Mountain Four Thousand Footers
//
//  Created by Nathan Beaumont on 11/1/20.
//

import Alamofire
import Foundation

struct APIRequestFactory {
    static func mountainPeaks() -> APIRequest<[MountainPeak]> {
        return APIRequest.init(methodType: HTTPMethod.get,
                               path: "mountain_peaks",
                               modelClass: Array<MountainPeak>.self)
    }

    static func createNewUser(newUser: RegisterInfo) -> APIRequest<UserToken> {
        var apirequest = APIRequest.init(methodType: HTTPMethod.post,
                                         path: "users/create",
                                         modelClass: UserToken.self)
        apirequest.parameters = [RegisterInfo.CodingKeys.email.stringValue: newUser.email,
                                 RegisterInfo.CodingKeys.name.stringValue: newUser.name,
                                 RegisterInfo.CodingKeys.password.stringValue: newUser.password]

        return apirequest
    }
}
