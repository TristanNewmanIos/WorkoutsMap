//
//  Place.swift
//  WorkoutsMap
//
//  Created by Tristan Newman on 11/6/20.
//

import Foundation
import CoreLocation

struct Place: Codable {
    var name: String?
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees
    
    enum KeyValue: String {
        case latitude = "placeLatitude"
        case longitude = "placeLongitude"
        case name = "placeName"
    }
    
    init(json: [String: Any?]) {
        name = json[KeyValue.name.rawValue] as? String
        latitude = CLLocationDegrees(json[KeyValue.latitude.rawValue] as? String ?? "") ?? 0.0
        longitude = CLLocationDegrees(json[KeyValue.longitude.rawValue] as? String ?? "") ?? 0.0
    }
    
    init(latitude: Double, longitude: Double, name: String?) {
        self.latitude = latitude
        self.longitude = longitude
        self.name = name
    }
}
