//
//  APIRequest.swift
//  White Mountain Four Thousand Footers
//
//  Created by Nathan Beaumont on 11/1/20.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

struct APIRequest<ModelClass: Codable> {

    // MARK: Stored Properties
    var host: String // i.e. https://api.example.com
    var version: String // i.e. v1/
    var methodType: HTTPMethod
    var modelClass: ModelClass.Type
    var path: String
    var parameters: [String: Any] = [:]

    var url: URL? {
        return URL(string: host + version + path)
    }

    struct Constants {
        static var APIVersion: String { "v1/" }
        static var HostName: String { "https://white-mountains-four-thousands.herokuapp.com/" }
    }

    init(methodType: HTTPMethod, path: String, modelClass: ModelClass.Type) {
        self.path = path
        self.host = Constants.HostName
        self.version = Constants.APIVersion
        self.methodType = methodType
        self.modelClass = modelClass
    }

    init(host: String, version: String , methodType: HTTPMethod, path: String, modelClass: ModelClass.Type) {
        self.path = path
        self.host = host
        self.version = version
        self.methodType = methodType
        self.modelClass = modelClass
    }
}
