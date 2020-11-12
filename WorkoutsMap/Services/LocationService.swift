//
//  LocationService.swift
//  WorkoutsMap
//
//  Created by Tristan Newman on 11/6/20.
//

import Foundation
import Alamofire
import CoreLocation
import MapKit

class LocationService: NSObject {
    
    let locationManager = CLLocationManager()
    var usersLocation: Place? {
        return getLocation()
    }
    
    let baseURLString = "https://stagingapi.campgladiator.com/api/v2"
    var getPlacesByDistanceExtension = "/places/searchbydistance?"
    
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
    
    func getPlacesByDistance(from place: Place, radius: Int, completion: @escaping (Result<Any, AFError>) -> Void) {
        let requestURLString = baseURLString + getPlacesByDistanceExtension + "lat=\(place.latitude)&lon=\(place.longitude)&radius=\(radius)"
        
        AF.request(requestURLString).validate().responseJSON { response in
            completion(response.result)
        }
        
    }
    
    func getDemoPlacesByDistance(radius: Int, completion: @escaping (Result<Any, AFError>) -> Void) {
        let requestURLString = baseURLString + getPlacesByDistanceExtension + "lat=30.406991&lon=-97.720310&radius=\(radius)"
        
        AF.request(requestURLString).validate().responseJSON { response in
            completion(response.result)
        }
        
    }
    
    func getSearchResults(for mapView: MKMapView, searchText: String, completion: @escaping (MKLocalSearch.Response?) -> Void)  {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        
        search.start { response, _ in
           completion(response)
        }
    }
}

extension LocationService: CLLocationManagerDelegate {
}
