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
    let latitudeDegreesOf2Miles = 0.02898550724
    let longitudeDegreesOf2Miles = 0.03663003663
    
    var getPlacesResponse: SearchByDistanceResponseObject?
    var workoutLocations: [Place] = []
    var locationRadius = 2 //miles
    var currentLocation = CLLocation()
    var mapItems = [MKMapItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getMapData()
        setUpView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    private func setUpView() {
        // Non-delegate map set up
        mapView.delegate = self
        currentLocation = mapView.userLocation.location ?? CLLocation()
        
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
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newLength = searchTextField.text?.utf16.count ?? 0 + 1

        // enable search button
        // check for non alpha characters
        if newLength > 2 {
            guard let searchText = searchTextField.text else {
                return true
            }
            getSearchResults(searchText: searchText)
        }
        
        return true
    }
}

extension MapViewController: MKMapViewDelegate {
    private func updateLocation(with mapItem: MKMapItem?) {
        guard let newMapItem = mapItem else {
            return
        }
        currentLocation = CLLocation(latitude: newMapItem.placemark.coordinate.latitude, longitude: newMapItem.placemark.coordinate.longitude)
        centerMap(coordinate: currentLocation.coordinate)
        annotateMap(placemark: newMapItem.placemark)
    }
    
    private func centerMap(coordinate: CLLocationCoordinate2D) {
        mapView.setCenter(coordinate, animated: true)
    }
    
    private func annotateMap(placemark: MKPlacemark) {
        // Clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.title
        
        mapView.addAnnotation(annotation)
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        mapView.showsUserLocation = true
        
        let latitudeDelta = CLLocationDegrees(latitudeDegreesOf2Miles)
        let longitudeDelta = CLLocationDegrees(longitudeDegreesOf2Miles)
        let coordinateSpan = MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
        let coordinateRegion = MKCoordinateRegion(center: currentLocation.coordinate, span: coordinateSpan)
        
        centerMap(coordinate: currentLocation.coordinate)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}

