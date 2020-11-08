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
    
    var usersLocation: Place? {
        return service.getLocation()
    }
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
    
    // MARK: Networking
    private func createMapData() {
        service.getPlacesByDistance(latitude: 2.0, longitude: 2.0, radius: 2)
        
    }

}

extension MapViewController: UITextFieldDelegate {
    
}

