//
//  Place.swift
//  WorkoutsMap
//
//  Created by Tristan Newman on 11/6/20.
//

import Foundation

struct Place: Codable {
    var longitude: Double
    var latitude: Double
    var name: String
    
    enum KeyValue: String {
        case latitude = "placeLatitude"
        case longitude = "placeLongitude"
        case name = "placeName"
    }
    
    init(json: [String: Any?]) {
        latitude = json[KeyValue.latitude.rawValue] as? Double ?? .zero
        longitude = json[KeyValue.longitude.rawValue] as? Double ?? .zero
        name = json[KeyValue.name.rawValue] as? String ?? ""
    }
}
