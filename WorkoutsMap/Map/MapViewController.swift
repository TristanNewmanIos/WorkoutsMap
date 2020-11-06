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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        searchTextField.becomeFirstResponder()
    }
    
    private func setUpView() {
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
        
        
    }

}

extension MapViewController: UITextFieldDelegate {
    
}

