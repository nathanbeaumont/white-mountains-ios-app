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
                     failure: ((Error, AFDataResponse<Any>) -> Void)? = nil) {
    guard let url = apiRequest.url else {
        return
    }

    let parameters = (apiRequest.methodType == Alamofire.HTTPMethod.get) ? nil : apiRequest.parameters
    AF.request(url,
               method: apiRequest.methodType,
               parameters: parameters,
               encoding: JSONEncoding.default)
      .validate()
      .responseJSON(completionHandler: { response in
        switch response.result {
        case .success:
          guard let data = response.data else {
            failure?(NSError(domain: url.path, code: response.response?.statusCode ?? 200,
                             userInfo: ["errorDescription": "Response data unable to convert to iOS domain"]), response)
            return
          }

          do {
            let model = try JSONDecoder().decode(apiRequest.modelClass, from: data)
            success(model)
          } catch {
            failure?(NSError(domain: url.path, code: response.response?.statusCode ?? 200,
                             userInfo: ["errorDescription": "Could not convert to model object"]), response)
          }

        case .failure(let error):
            failure?(error, response)
        }
      })
  }
}
