//
//  APIRequestFactory.swift
//  White Mountain Four Thousand Footers
//
//  Created by Nathan Beaumont on 11/1/20.
//

import Foundation

struct APIRequestFactory {

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


    static func removeMountainBag(mountainId: Int) -> APIRequest<APIError> {
        var apirequest = APIRequest.init(methodType: HTTPMethod.delete,
                                         path: "remove_bag",
                                         modelClass: APIError.self)
        apirequest.parameters = [MountainBag.CodingKeys.mountainId.stringValue: mountainId]
        return apirequest
    }

    static func mountainsPeaksBagged() -> APIRequest<[MountainBag]> {
        return APIRequest.init(methodType: HTTPMethod.get,
                               path: "bag",
                               modelClass: Array<MountainBag>.self)
    }
}
