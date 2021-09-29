//
//  MountainPeak.swift
//  White Mountain Four Thousand Footers
//
//  Created by Nathan Beaumont on 11/1/20.
//

import CoreData
import Foundation

class MountainPeak: NSManagedObject, Codable {
    @NSManaged var ascent: Int
    @NSManaged var elevation: Int
    @NSManaged var id: Int
    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
    @NSManaged var name: String
    @NSManaged var infoUrls: String

    enum CodingKeys: String, CodingKey {
        case ascent
        case elevation
        case id = "mountain_id"
        case latitude
        case longitude
        case name = "mountain_name"
        case infoUrls = "mountain_info_urls"
    }

    convenience init(ascent: Int,
                     elevation: Int,
                     id: Int,
                     latitude: Double,
                     longitude: Double,
                     name: String,
                     infoUrls: String) {
        self.init()

        self.ascent = ascent
        self.elevation = elevation
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
        self.name = name
        self.infoUrls = infoUrls
    }

    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.ascent = try container.decode(Int.self, forKey: .ascent)
        self.elevation = try container.decode(Int.self, forKey: .elevation)
        self.id = try container.decode(Int.self, forKey: .id)
        self.latitude = try container.decode(Double.self, forKey: .latitude)
        self.longitude = try container.decode(Double.self, forKey: .longitude)
        self.name = try container.decode(String.self, forKey: .name)
        self.infoUrls = try container.decode(String.self, forKey: .infoUrls)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(ascent, forKey: .ascent)
        try container.encode(elevation, forKey: .elevation)
        try container.encode(id, forKey: .id)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
        try container.encode(name, forKey: .name)
        try container.encode(infoUrls, forKey: .infoUrls)
    }
}

extension MountainPeak {
    var urls: [URL] {
        let strings = infoUrls.split(separator: ",")
        var urls = [URL]()

        for url in strings {
            if let verifiedURL = URL(string: String(url)) {
                urls.append(verifiedURL)
            }
        }

        return urls
    }
}
