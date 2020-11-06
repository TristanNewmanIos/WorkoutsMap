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
    func getLocation() -> Place {
        // Set up
        let locationManager = CLLocationManager()
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        
        return Place(
            latitude: Double(locationManager.location?.coordinate.latitude ?? .zero),
            longitude: Double(locationManager.location?.coordinate.longitude ?? .zero),
            name: nil
        )
    }
    
    func getPlacesByDistance(latitude: Double, longitude: Double, radius: Int) {
        
    }
}

extension LocationService: CLLocationManagerDelegate {
    
}
