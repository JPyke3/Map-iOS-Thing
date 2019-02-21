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

class DescriptionViewController: UIViewController {
    
    @IBOutlet weak var cafeName: UILabel!
    @IBOutlet weak var cafeDescription: UILabel!
    @IBOutlet weak var bestBarista: UILabel!
    @IBOutlet weak var bestCoffee: UILabel!

    var lastCafeName: String = MenuViewController.lastTouchedAnnotation
    
    override func viewDidLoad() {
        // View Loaded
        super.viewDidLoad()
        loadLocations()
    }
    
    func loadLocations() {
        //        Load the database with the name "Shops" and generate the Data as locationSnap
        Database.database().reference().child("shops").queryOrdered(byChild: "id").observe(DataEventType.value, with: {(locationSnap) in
            //        Convert the values of locationSnap into a dictionary called locationDict
            if let locationDict = locationSnap.value as? [String:AnyObject] {
                //                For all of the key value pairs in locationDict, take the key values
                for (key, _) in locationDict {
                    //                    Then grab all of the value pairs within (Essentially grabbing all of the details about thee store location and etc.)
                    if let store = locationDict[key] as? [String:AnyObject] {
                        let isEqual = (store["name"] as? String ?? "" == self.lastCafeName)
                        if isEqual == true {
                            let lat = store["lat"] as! Double
                            let lng = store["lng"] as! Double
                            let name = store["name"] as! String
                            let desc = store["desc"] as! String
                            let rating = store["rating"] as! Int
                            let barista = store["bbarista"] as! String
                            let coffee = store["bcoffee"] as! String
                            let id = store["id"] as! Int
                            self.cafeName.text = name
//                            self.cafeDescription.text = desc
//                            self.bestCoffee.text = coffee
//                            self.bestBarista.text = barista
                        }
                    }
                }
            }
        })
    }
}
