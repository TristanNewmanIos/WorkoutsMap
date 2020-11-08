//
//  MapViewController.swift
//  WorkoutsMap
//
//  Created by Tristan Newman on 11/6/20.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    let service = LocationService()
    var getPlacesResponse: SearchByDistanceResponseObject?
    var workoutLocations: [Place] = []
    var locationRadius = 2 //miles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createMapData()
        setUpView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    private func setUpView() {
        setUpSearchBox()
        setUpMap()
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
        mapView.showsUserLocation = true
    }
    
    // MARK: Data Processing
    private func createMapData() {
        getMapData()
        
    }
    
    // MARK: Networking
    private func getMapData() {

        let group = DispatchGroup()
        
        group.enter()
        // service.getPlacesByDistance(radius: locationRadius)
        // TODO: Switch to normal get request before prod
        service.getDemoPlacesByDistance(radius: 25) { result in
            switch result {
            case .success(let value):
                print(value)
                self.getPlacesResponse = SearchByDistanceResponseObject(responseData: value)
            case .failure(let error):
                print(error)
            }
            
            group.leave()
        }
        
        DispatchQueue.main.async {
            if let workoutPlaces = self.getPlacesResponse?.places {
                self.workoutLocations = workoutPlaces
            }
        }
    }

}

extension MapViewController: UITextFieldDelegate {
    
}

