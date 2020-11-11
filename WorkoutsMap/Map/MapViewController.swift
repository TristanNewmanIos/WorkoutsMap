//
//  MapViewController.swift
//  WorkoutsMap
//
//  Created by Tristan Newman on 11/6/20.
//
// LAT and LONG conversion NOTES:
// One degree of latitude equals approximately 364,000 feet (69 miles), one minute equals 6,068 feet (1.15 miles), and one-second equals 101 feet.
// One-degree of longitude equals 288,200 feet (54.6 miles), one minute equals 4,800 feet (0.91 mile), and one second equals 80 feet.

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    let service = LocationService()
    
    // User Default Location Specs
    let latitudeDegreesOf25Miles = 0.3623188406
    let longitudeDegreesOf25Miles = 0.457875457875458
    
    var getPlacesResponse: SearchByDistanceResponseObject?
    var workoutLocations: [Place] = []
    var locationRadius = 25 //miles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getMapData()
        setUpView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    private func setUpView() {
        mapView.delegate = self
        setUpSearchBox()
    }
    
    private func setUpSearchBox() {
        searchTextField.delegate = self
        
        // Add borders
        searchTextField.layer.borderWidth = 1
        searchTextField.layer.borderColor = UIColor.gray.cgColor
        searchTextField.layer.cornerRadius = 4
        
        // Add shadow
        searchTextField.layer.shadowOpacity = 1
        searchTextField.layer.shadowRadius = 1
        searchTextField.layer.shadowColor = UIColor.black.cgColor
        searchTextField.layer.shadowOffset = .zero
        
        searchTextField.becomeFirstResponder()
    }
    
    private func setUpMap() {

    }
    
    // MARK: Networking
    private func getMapData() {

        let group = DispatchGroup()
        
        group.enter()
        // service.getPlacesByDistance(radius: locationRadius)
        // TODO: Switch to normal get request before prod
        service.getDemoPlacesByDistance(radius: locationRadius) { result in
            switch result {
            case .success(let value):
                self.getPlacesResponse = SearchByDistanceResponseObject(responseData: value as? [String: Any] ?? [:])
            case .failure(let error):
                print(error)
            }
            
            group.leave()
        }
        
        group.notify(queue: DispatchQueue.main, execute: {
            // MARK: Build places array
            if let workoutPlaces = self.getPlacesResponse?.places {
                self.workoutLocations = workoutPlaces
            }
        })
    }

}

extension MapViewController: UITextFieldDelegate {
}

extension MapViewController: MKMapViewDelegate {
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        mapView.showsUserLocation = true
        
        let latitudeDelta25Miles = CLLocationDegrees(latitudeDegreesOf25Miles)
        let longitudeDelta25Miles = CLLocationDegrees(longitudeDegreesOf25Miles)
        let coordinateSpan = MKCoordinateSpan(latitudeDelta: latitudeDelta25Miles, longitudeDelta: longitudeDelta25Miles)
        let coordinateRegion = MKCoordinateRegion(center: mapView.userLocation.coordinate, span: coordinateSpan)
        
        mapView.setCenter(mapView.userLocation.coordinate, animated: true)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}

