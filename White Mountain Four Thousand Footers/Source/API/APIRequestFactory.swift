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
}
