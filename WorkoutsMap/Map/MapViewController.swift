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
    
    // Dallas test Location
    let dallasLatitude = 32.779167
    let dallasLongitude = -96.808891
    
    var getPlacesResponse: SearchByDistanceResponseObject?
    var workoutLocations: [Place] = []
    var locationRadius = 25 //miles
    var currentLocation = CLLocation()
    var mapItems = [MKMapItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setUpMap()
        getMapData()
    }
    
    private func setUpView() {
        // Non-delegate map set up
        mapView.delegate = self
        
        setUpSearchBox()
        setUpMap()
    }
    
    private func setUpMap() {
        mapView.showsUserLocation = true
        
        if let userLocation = mapView.userLocation.location {
            currentLocation = userLocation
        }
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
        searchTextField.enablesReturnKeyAutomatically = true
    }
    
    // MARK: Networking
    private func getMapData() {

        let group = DispatchGroup()
        
        group.enter()
        service.getPlacesByDistance (from: Place(
                                        latitude: currentLocation.coordinate.latitude,
                                        longitude: currentLocation.coordinate.longitude,
                                        name: nil),radius: locationRadius) { result in
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
                self.annotateMapUI(with: self.workoutLocations)
            }
        })
    }
    
    private func annotateMapUI(with places: [Place]) {
        places.forEach {
            annotateMap(place: $0)
        }
    }
    
    private func getSearchResults(searchText: String) {
        let group = DispatchGroup()
        var response: MKLocalSearch.Response?
        
        group.enter()
        service.getSearchResults(for: mapView, searchText: searchText) { result in
            
            response = result
            group.leave()
        }
        
        group.notify(queue: DispatchQueue.main, execute: {
            if let responseItems = response?.mapItems {
                self.mapItems = responseItems
                self.updateLocation(with: self.mapItems.first)
            }
        })
    }

}

extension MapViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // check for non alpha characters
        // Count chars
        let newLength = searchTextField.text?.utf16.count ?? 0

        if newLength > 2 {
            guard let searchText = searchTextField.text else {
                return false
            }
            getSearchResults(searchText: searchText)
            return true
        }
        
        return false
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        currentLocation = mapView.userLocation.location ?? CLLocation()
        
        return true
    }
}

extension MapViewController: MKMapViewDelegate {
    private func updateLocation(with mapItem: MKMapItem?) {
        guard let newMapItem = mapItem else {
            return
        }
        
        currentLocation = CLLocation(latitude: newMapItem.placemark.coordinate.latitude, longitude: newMapItem.placemark.coordinate.longitude)
        annotateMap(place: Place(latitude: newMapItem.placemark.coordinate.latitude, longitude: newMapItem.placemark.coordinate.longitude, name: newMapItem.placemark.title))
    }
    
    private func centerMap(coordinate: CLLocationCoordinate2D) {
        mapView.setCenter(coordinate, animated: true)
    }
    
    private func annotateMap(place: Place) {
        // Clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
        annotation.title = place.name
        
        mapView.addAnnotation(annotation)
    }
    
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        mapView.showsUserLocation = true
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        // TODO: Remove centering on dallas
//        currentLocation = CLLocation(latitude: dallasLatitude, longitude: dallasLongitude)
        guard let userNewLocation = mapView.userLocation.location else { return }
        currentLocation = userNewLocation
        
        let latitudeDelta = CLLocationDegrees(latitudeDegreesOf25Miles)
        let longitudeDelta = CLLocationDegrees(longitudeDegreesOf25Miles)
        let coordinateSpan = MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
        let coordinateRegion = MKCoordinateRegion(center: currentLocation.coordinate, span: coordinateSpan)

        mapView.setRegion(coordinateRegion, animated: true)
        
        
    }
        
    }


