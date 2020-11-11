//
//  SearchByDistanceResponseObject.swift
//  WorkoutsMap
//
//  Created by Tristan Newman on 11/6/20.
//

import Foundation

struct SearchByDistanceResponseObject {
    var places: [Place] = []
    
    private enum Key: String {
        case data
    }
    
    private enum DataKey: String {
        case location
    }
    
    init(responseData: [String: Any]) {
        let jsonData: [[String: Any]] = responseData[Key.data.rawValue] as? [[String: Any]] ?? [[:]]
        
        // sets placesJson to nested locations data
        jsonData.forEach{
            places.append(Place(json: $0))
        }
    }
}
