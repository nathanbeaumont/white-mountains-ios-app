//
//  APIClient.swift
//  White Mountain Four Thousand Footers
//
//  Created by Nathan Beaumont on 11/1/20.
//

import Alamofire
import Foundation

class APIClient<APIModel: Codable> {
  enum FailureReason: Int, Error {
    case unAuthorized = 401
    case notFound = 404
  }

  class func perform(request apiRequest: APIRequest<APIModel>,
                     success: @escaping (APIModel) -> Void,
                     failure: ((Error) -> Void)? = nil) {
    guard let url = apiRequest.url else {
        return
    }

    AF.request(url)
      .validate()
      .responseJSON(completionHandler: { response in
        switch response.result {
        case .success:
          guard let data = response.data else {
            failure?(NSError(domain: url.path, code: response.response?.statusCode ?? 200,
                            userInfo: ["errorDescription": "Could not convert to model object"]))
            return
          }

          do {
            let model = try JSONDecoder().decode(apiRequest.modelClass, from: data)
            success(model)
          } catch {
            failure?(NSError(domain: url.path, code: response.response?.statusCode ?? 200,
                            userInfo: ["errorDescription": "Could not convert to model object"]))
          }

        case .failure(let error):
            failure?(error)
        }
      })
  }
}
