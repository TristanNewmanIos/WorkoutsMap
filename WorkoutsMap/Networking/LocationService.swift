//
//  LocationService.swift
//  WorkoutsMap
//
//  Created by Tristan Newman on 11/6/20.
//

import Foundation
import Alamofire
import CoreLocation

class LocationService: NSObject {
    
    typealias CompletionHandler = (_ success: Bool) -> Void
    
    let locationManager = CLLocationManager()
    let baseURLString = "https://stagingapi.campgladiator.com/api/v2/places/searchbydistance?lat=30.406991&lon=-97.720310&radius=25"
    
    override init() {
        super.init()
        
        // Set up
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Location permissions
        locationManager.requestWhenInUseAuthorization()
    }
    
    func getLocation() -> Place? {
        locationManager.startUpdatingLocation()
        
        if let location = locationManager.location?.coordinate {
           return Place(
                latitude: Double(location.latitude),
                longitude: Double(location.longitude),
                name: nil
            )
        }
        
        return nil
    }
    
    func getPlacesByDistance(latitude: Double, longitude: Double, radius: Int) {
        AF.request(baseURLString).validate().responseJSON { response in
            print("response data: ", response)
        }
        
    }
}

extension LocationService: CLLocationManagerDelegate {
    
}
