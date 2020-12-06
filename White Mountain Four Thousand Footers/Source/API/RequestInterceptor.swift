//
//  RequestInterceptor.swift
//  White Mountain Four Thousand Footers
//
//  Created by Nathan Beaumont on 11/28/20.
//

import Alamofire
import Foundation


final class RequestInterceptor: Alamofire.RequestInterceptor {

    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        guard urlRequest.url?.absoluteString.hasPrefix(APIRequest<MountainPeak>.Constants.HostName) == true else {
            /// If the request does not require authentication, we can directly return it as unmodified.
            return completion(.success(urlRequest))
        }

        var urlRequest = urlRequest
        if let userToken = KeyChain.shared.userAccessToken {
            urlRequest.setValue("Bearer " + userToken, forHTTPHeaderField: "Authorization")
        }

        completion(.success(urlRequest))
    }

    func retry(_ request: Request, for session: Session,
               dueTo error: Error,
               completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
            KeyChain.shared.userAccessToken = nil
            return completion(.doNotRetryWithError(error))
        }
    }
}
