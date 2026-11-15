//
//  APIClient.swift
//  White Mountain Four Thousand Footers
//
//  Created by Nathan Beaumont on 11/1/20.
//

import CoreData
import Foundation
import SwiftUI

enum APIClientError: Error {
    case invalidURL
    case invalidResponse
    case unauthorized
    case httpStatus(Int)
    case decoding(underlying: Error, statusCode: Int)

    /// HTTP status code, when the failure came from the server's response.
    var statusCode: Int? {
        switch self {
            case .unauthorized: return 401
            case .httpStatus(let code): return code
            case .decoding(_, let code): return code
            case .invalidURL, .invalidResponse: return nil
        }
    }
}

final class APIClient {

    static let shared = APIClient()
    private init() {}

    private(set) var performingRequest: Bool = false
    private var activeRequestCount = 0

    private let session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 25
        return URLSession(configuration: configuration)
    }()

    // MARK: Async API

    func send<APIModel: Codable>(_ apiRequest: APIRequest<APIModel>,
                                 showLoadingIndicator: Bool = true) async throws -> APIModel {
        guard let url = apiRequest.url else { throw APIClientError.invalidURL }

        let urlRequest = try makeURLRequest(for: apiRequest, url: url)

        if showLoadingIndicator { updateActiveRequests(by: 1) }
        defer { if showLoadingIndicator { updateActiveRequests(by: -1) } }

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(for: urlRequest)
        } catch {
            print("API Request Failed:\n\(error)")
            throw error
        }

        guard let httpResponse = response as? HTTPURLResponse else { throw APIClientError.invalidResponse }

        guard (200..<300).contains(httpResponse.statusCode) else {
            print("API Request Failed: \(url.path) status \(httpResponse.statusCode)")
            if httpResponse.statusCode == 401 {
                await MainActor.run {
                    NotificationCenter.default.post(name: .APIRequestUnauthroizedUser, object: nil)
                }
                throw APIClientError.unauthorized
            }
            throw APIClientError.httpStatus(httpResponse.statusCode)
        }

        // Decoding uses the view context, so it must happen on the main actor.
        return try await MainActor.run {
            let decoder = JSONDecoder()
            decoder.userInfo[CodingUserInfoKey.managedObjectContext] = PersistenceController.shared.container.viewContext

            do {
                return try decoder.decode(apiRequest.modelClass, from: data)
            } catch {
                // Some endpoints return an empty 200 on success.
                if httpResponse.statusCode == 200,
                   let emptySuccess = APIError(error: "API success, Empty 200 response.") as? APIModel {
                    return emptySuccess
                }
                throw APIClientError.decoding(underlying: error, statusCode: httpResponse.statusCode)
            }
        }
    }

    // MARK: Completion-handler API (callbacks always delivered on the main thread)

    func performBackgroundRequest<APIModel: Codable>(request apiRequest: APIRequest<APIModel>,
                                                     success: ((APIModel) -> Void)?,
                                                     failure: ((Error) -> Void)? = nil) {
        perform(request: apiRequest, showLoadingIndicator: false,
                success: { success?($0) }, failure: failure)
    }

    func perform<APIModel: Codable>(request apiRequest: APIRequest<APIModel>,
                                    showLoadingIndicator: Bool = true,
                                    success: @escaping (APIModel) -> Void,
                                    failure: ((Error) -> Void)? = nil) {
        Task { @MainActor in
            do {
                let model = try await send(apiRequest, showLoadingIndicator: showLoadingIndicator)
                success(model)
            } catch {
                failure?(error)
            }
        }
    }

    // MARK: Helpers

    private func makeURLRequest<APIModel: Codable>(for apiRequest: APIRequest<APIModel>, url: URL) throws -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = apiRequest.methodType.rawValue

        if apiRequest.methodType != .get, !apiRequest.parameters.isEmpty {
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: apiRequest.parameters)
        }

        // Only attach the access token to requests going to our own API.
        if url.absoluteString.hasPrefix(APIRequest<MountainPeak>.Constants.HostName),
           let userToken = KeyChain.shared.userAccessToken {
            urlRequest.setValue("Bearer " + userToken, forHTTPHeaderField: "Authorization")
        }

        return urlRequest
    }

    private func updateActiveRequests(by delta: Int) {
        DispatchQueue.main.async { [self] in
            activeRequestCount += delta
            performingRequest = activeRequestCount > 0
            NotificationCenter.default.post(name: .APIRequestStatusChange, object: nil)
        }
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
