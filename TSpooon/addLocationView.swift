//
//  addLocationViewController.swift
//  TSpooon
//
//  Created by Jacob Pyke on 28.01.19.
//  Copyright © 2019 Pykee Co. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import Firebase

class addLocationViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var locationManager = CLLocationManager()
    
    let regionInMeters: Double = 100
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        // View Loaded
        checkLocationAuth()
        setupMapLocation()
    }
    
    func checkLocationAuth () {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            //            Do Map Stuff
            mapView.showsUserLocation = true
            centerViewOnUsersLocation()
            locationManager.startUpdatingLocation()
            break
        case .denied:
            //            Show an alert how to enable location Permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            //            Check with Parental Control Restrictions
            break
        case .authorizedAlways:
            break
        }
    }
    
    func centerViewOnUsersLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationServices() {
        //        If location is enabled
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            //            Check the authorization level
            checkLocationAuth()
        } else {
            //            Show alert saying that the location services are not enabled
        }
    }
        

    
    func setupMapLocation() {
        //Setup the mini map view at the bottom of the screen
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
        
    }
}
