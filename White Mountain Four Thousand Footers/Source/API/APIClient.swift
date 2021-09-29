//
//  APIClient.swift
//  White Mountain Four Thousand Footers
//
//  Created by Nathan Beaumont on 11/1/20.
//

import Alamofire
import CoreData
import Foundation
import SwiftUI

final class APIClient {
    enum FailureReason: Int, Error {
        case unAuthorized = 401
        case notFound = 404
    }

    static let shared = APIClient()
    private init() {}

    var performingRequest: Bool = false
    private var activeRequests = [Request]() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let weakSelf = self else { return }
                weakSelf.performingRequest = weakSelf.activeRequests.count > 0 ? true : false
                NotificationCenter.default.post(Notification(name: Notification.Name.APIRequestStatusChange))
            }
        }
    }


    lazy var sessionManager: Session = {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 25
        return Session(configuration: configuration,
                       interceptor: RequestInterceptor())
    }()

    func performBackgroundRequest<APIModel: Codable>(request apiRequest: APIRequest<APIModel>,
                                                     success: ((APIModel) -> Void)?,
                                                     failure: ((Error, AFDataResponse<Any>) -> Void)? = nil) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.perform(request: apiRequest, showLoadingIndicator: false) { model in
                DispatchQueue.main.async {
                    success?(model)
                }
            } failure: { error, response in
                DispatchQueue.main.async {
                    failure?(error, response)
                }
            }
        }
    }

    func perform<APIModel: Codable>(request apiRequest: APIRequest<APIModel>,
                                    showLoadingIndicator: Bool = true,
                                    success: @escaping (APIModel) -> Void,
                                    failure: ((Error, AFDataResponse<Any>) -> Void)? = nil) {
        guard let url = apiRequest.url else {
            return
        }

        let parameters = (apiRequest.methodType == Alamofire.HTTPMethod.get) ? nil : apiRequest.parameters
        let request = sessionManager.request(url,
                                             method: apiRequest.methodType,
                                             parameters: parameters,
                                             encoding: JSONEncoding.default)
        if showLoadingIndicator { activeRequests.append(request) }

        request
            .validate()
            .responseJSON(completionHandler: { [self] response in
                if showLoadingIndicator { self.activeRequests.removeAll { $0 == request } }

                switch response.result {
                    case .success:
                        guard let data = response.data else {
                            failure?(NSError(domain: url.path, code: response.response?.statusCode ?? 999,
                                             userInfo: ["errorDescription": "Response data unable to convert to iOS domain"]), response)
                            return
                        }

                        do {
                            let managedObjectContext = PersistenceController.shared.container.viewContext
                            let decoder = JSONDecoder()
                            decoder.userInfo[CodingUserInfoKey.managedObjectContext] = managedObjectContext

                            let model = try decoder.decode(apiRequest.modelClass, from: data)
                            success(model)
                        } catch {
                            if response.response?.statusCode  == 200 {
                                success(APIError(error: "API success, Empty 200 response.") as! APIModel)
                                
                                return
                            }

                            failure?(NSError(domain: url.path, code: response.response?.statusCode ?? 999,
                                             userInfo: ["errorDescription": "Could not convert to model object"]), response)
                        }

                    case .failure(let error):
                        print("API Request Failed:")
                        print("\(error)")
                        failure?(error, response)
                }
            })
  }
}

// MARK: Database Stores

extension APIClient {
    func saveContext(managedObjectContext: NSManagedObjectContext) {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                print("An error occurred while saving: \(error)")
            }
        }
    }
}
