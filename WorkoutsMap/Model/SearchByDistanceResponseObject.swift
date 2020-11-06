//
//  SearchByDistanceResponseObject.swift
//  WorkoutsMap
//
//  Created by Tristan Newman on 11/6/20.
//

import Foundation

struct SearchByDistanceResponseObject {
    var places: [Place] = []
    
    init(responseData: Any?) {
        var placesJson: [String: Any?] = [:]
        
        // sets placesJson to nested locations data
        
        placesJson.forEach{
            places.append(Place(json: [$0.key: $0.value]))
        }
    }
}
