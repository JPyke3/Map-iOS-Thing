//
//  MenuViewController.swift
//  TSpooon
//
//  Created by Jacob Pyke on 23.01.19.
//  Copyright © 2019 Pykee Co. All rights reserved.
//

//Officially GitHub Powered
//Imports
import Foundation
import UIKit
import SceneKit
import Firebase
import FirebaseAuth
import GoogleSignIn
import FirebaseDatabase
import GoogleMaps
import CoreLocation
import MapKit
import MaterialComponents.MaterialBottomAppBar

//The Class for the custom pins on the map
class customPin: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(pinTitle:String, pinSubTitle:String, location:CLLocationCoordinate2D) {
        self.title = pinTitle
        self.subtitle = pinSubTitle
        self.coordinate = location
    }
}


class MenuViewController : UIViewController, CLLocationManagerDelegate, MKMapViewDelegate{
//    The MapView Outlet
    @IBOutlet weak var mapView: MKMapView!
    
//    The Outlets for all of the Location Toast
    @IBOutlet weak var locationCardTitle: UILabel!
    @IBOutlet weak var locationCardDescription: UILabel!
    @IBOutlet weak var toastForPin: MDCCard!
    @IBOutlet weak var toastForPinConstraint: NSLayoutConstraint!
    @IBOutlet weak var naviButtonBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var menuViewTop: UIView!
    
    
//    The Outlet for the Menu Constraint
    @IBOutlet weak var menuViewBounce: NSLayoutConstraint!
    
//    The Outlet for the Navigation Button (The Silver One)
    @IBOutlet weak var naviButton: MDCFloatingButton!
    
//    Outlet for toast Name Label
    @IBOutlet weak var nameLabel: UILabel!
    
//    The Dismiss button on the menu bar
    @IBAction func dismissButtonPressed(_ sender: Any) {
            print("Dismiss")
            menuViewBounce.constant = -1 * self.view.frame.size.width
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
//    The menu Button on the top bar with the search (Summons the menu slider)
    @IBAction func menuButtonPressed(_ sender: Any) {
            menuViewBounce.constant = 0
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    
    
    @IBAction func toastPressed(_ sender: Any) {
        print("Toast!")
        print("Powered By Github!")
        performSegue(withIdentifier: "mapToDescription", sender: Any?.self)
    }
    
    @IBAction func pressedToast(_ sender: Any) {
        print("Toast!")
        print("Powered By Github!")
        performSegue(withIdentifier: "mapToDescription", sender: Any?.self)
    }
    
    
    
    static var lastTouchedAnnotation: String = ""
    
//    The Firebase Database Reference
    var ref: DatabaseReference!
//    Location Manager
    var locationManager = CLLocationManager()
//    Location Range
    let regionInMeters: Double = 10000
    
//    When the view loaded
    override func viewDidLoad() {
        loadCustomLocations()
        checkLocationServices()
        loadMaterialDesign()
        loadFirebase()
    }
    
    func loadFirebase() {
        let user = Auth.auth().currentUser
        nameLabel.text = user?.displayName
    }
    
//    The initialization of all the material design components
    func loadMaterialDesign() {
        self.view.backgroundColor = ApplicationScheme.shared.colorScheme.surfaceColor
    }
//    Setup the location Manager Delegate
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
//    When the Map Initially loads, zoom on the users location
    func centerViewOnUsersLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
//    Check for Location Services.
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
//    Check how authorized we are in order to use the users location
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
//    Load all of the locations that are within the Firebase database
    func loadCustomLocations() {
//        Load the database with the name "Shops" and generate the Data as locationSnap
    Database.database().reference().child("shops").queryOrdered(byChild: "id").observe(DataEventType.value, with: {(locationSnap) in
//        Convert the values of locationSnap into a dictionary called locationDict
            if let locationDict = locationSnap.value as? [String:AnyObject] {
//                For all of the key value pairs in locationDict, take the key values
                for (key, _) in locationDict {
//                    Then grab all of the value pairs within (Essentially grabbing all of the details about thee store location and etc.)
                    if let store = locationDict[key] as? [String:AnyObject] {
                        let lat = store["lat"] as! Double
                        let lng = store["lng"] as! Double
                        let name = store["name"] as! String
                        let desc = store["desc"] as! String
                        let location = CLLocationCoordinate2D(latitude: lat, longitude: lng)
//                        Create a pin with the name of the location, description and using the location
                        let pin = customPin(pinTitle: name, pinSubTitle: desc, location: location)
//                        Add an annotation.
                        self.mapView.addAnnotation(pin)
                        self.mapView.delegate = self
                    }
                }
            }
        })
    }
    
//    Set the view for the annotations
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        If the annotation is the users location, dont do anything
        if annotation is MKUserLocation {
            return nil
        }
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "customAnnotation")
        annotationView.image = UIImage(named: "locationImage")
        annotationView.canShowCallout = false
        return annotationView
    }
    
//    Function for the selection of an annotation on the map.
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        toastForPinConstraint.constant = 7.5
        naviButtonBottomConstraint.constant += (self.toastForPin.frame.height - 25)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        locationCardTitle.text = view.annotation?.title ?? "Title"
        MenuViewController.lastTouchedAnnotation = (view.annotation?.title)! ?? "No Data Passed"
        locationCardDescription.text = view.annotation?.subtitle ?? "Subtitle"
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        naviButtonBottomConstraint.constant -= (self.toastForPin.frame.height - 25)
        toastForPinConstraint.constant = -500
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: -5, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuth()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let firstTouch = touches.first {
            let hitView = self.view.hitTest(firstTouch.location(in: self.view), with: event)
            
            if hitView !== menuView {
                if hitView !== menuViewTop {
                    menuViewBounce.constant = -1 * self.view.frame.size.width
                    UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
                        self.view.layoutIfNeeded()
                    }, completion: nil)
                    view.endEditing(true)
                }
            }
        }
    }
}
