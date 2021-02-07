//
//  APIRequestFactory.swift
//  White Mountain Four Thousand Footers
//
//  Created by Nathan Beaumont on 11/1/20.
//

import Alamofire
import Foundation

struct APIRequestFactory {

    // MARK: Registration Requests

    static func createNewUser(newUser: RegisterInfo) -> APIRequest<UserToken> {
        var apirequest = APIRequest.init(methodType: HTTPMethod.post,
                                         path: "users/create",
                                         modelClass: UserToken.self)
        apirequest.parameters = [RegisterInfo.CodingKeys.email.stringValue: newUser.email,
                                 RegisterInfo.CodingKeys.name.stringValue: newUser.name,
                                 RegisterInfo.CodingKeys.password.stringValue: newUser.password]

        return apirequest
    }

    static func initiateForgotPassword(emailAddress: String) -> APIRequest<APIError> {
        var apirequest = APIRequest.init(methodType: HTTPMethod.post,
                                         path: "users/password_reset",
                                         modelClass: APIError.self)
        let passwordReset = PasswordReset(emailAddress: emailAddress)
        KeyChain.shared.mostRecentPasswordResetToken = passwordReset
        apirequest.parameters = [PasswordReset.CodingKeys.email.stringValue: passwordReset.email,
                                 PasswordReset.CodingKeys.resetToken.stringValue: passwordReset.resetToken.uuidString]

        return apirequest
    }

    static func signInUser(userCrudentials: SignInInfo) -> APIRequest<UserToken> {
        var apirequest = APIRequest.init(methodType: HTTPMethod.post,
                                         path: "users/login",
                                         modelClass: UserToken.self)
        apirequest.parameters = [SignInInfo.CodingKeys.email.stringValue: userCrudentials.email,
                                 SignInInfo.CodingKeys.password.stringValue: userCrudentials.password]
        return apirequest
    }

    static func deleteUser() -> APIRequest<APIError> {
        return APIRequest.init(methodType: HTTPMethod.delete,
                                         path: "users/remove",
                                         modelClass: APIError.self)
    }

    // MARK: Mountain Peak Requests

    static func mountainPeaks() -> APIRequest<[MountainPeak]> {
        return APIRequest.init(methodType: HTTPMethod.get,
                               path: "mountain_peaks",
                               modelClass: Array<MountainPeak>.self)
    }

    static func bagMountainPeak(mountainId: Int) -> APIRequest<MountainBag> {
        var apirequest = APIRequest.init(methodType: HTTPMethod.post,
                                         path: "bag",
                                         modelClass: MountainBag.self)
        apirequest.parameters = [MountainBag.CodingKeys.mountainId.stringValue: mountainId]
        return apirequest
    }

    static func mountainsPeaksBagged() -> APIRequest<[MountainBag]> {
        return APIRequest.init(methodType: HTTPMethod.get,
                               path: "bag",
                               modelClass: Array<MountainBag>.self)
    }
}
