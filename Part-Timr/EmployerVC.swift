//
//  EmployerVC.swift
//  Part-Timr for Employer
//
//  Created by Michael V. Corpus on 11/02/2017.
//  Copyright © 2017 Michael V. Corpus. All rights reserved.
//

import UIKit
import MapKit

class EmployerVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, ParttimrController {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var callParttimrBtn: UIButton!
    private var locationManager = CLLocationManager()
    private var userLocation: CLLocationCoordinate2D?
//    private var hirerLocation: CLLocationCoordinate2D?
    
    private var canCallParttimr = true
    private var employerCanceledRequest = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeLocationManager()
        HireHandler.Instance.observeMessagesForEmployer()
        HireHandler.Instance.delegate = self
    }
    
    private func initializeLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locationManager.location?.coordinate {
            
            userLocation = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            
            let region = MKCoordinateRegion(center: userLocation!, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            
            mapView.setRegion(region, animated: true)
            mapView.removeAnnotations(mapView.annotations)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = userLocation!
            annotation.title = "Hirer's Location"
            mapView.addAnnotation(annotation)
            
        }
        
    }

    func canCallParttimr(delegateCalled: Bool) {
        if delegateCalled {
            callParttimrBtn.setTitle("Cancel", for: UIControlState.normal)
            canCallParttimr = false
        } else {
            callParttimrBtn.setTitle("Hire!", for: UIControlState.normal)
            canCallParttimr = true
        }
    }
    
    @IBAction func Hire(_ sender: Any) {
        if userLocation != nil {
            if canCallParttimr {
                HireHandler.Instance.requestParttimr(latitude: Double (userLocation!.latitude), longitude: Double (userLocation!.longitude))
            } else {
                employerCanceledRequest = true
                HireHandler.Instance.cancelParttimr()
            }
        }
    }
    
    @IBAction func logOut(_ sender: Any) {
        
        if AuthProvider.Instance.logOut() {
            dismiss(animated: true, completion: nil)
            
            print("LOGOUT SUCCESSFUL")
            
        } else {
            self.alertTheUser(title: "Problem logging out", message: "Please try again later.")
        }
        
    }

    

    
    func alertTheUser(title: String, message: String)  {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction (UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated:true, completion: nil)
    }

   

}
