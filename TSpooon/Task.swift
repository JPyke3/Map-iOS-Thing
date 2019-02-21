//
//  Task.swift
//  TSpooon
//
//  Created by Jacob Pyke on 24.01.19.
//  Copyright © 2019 Pykee Co. All rights reserved.
//

import Foundation
import Firebase

struct latLong {
    
    /* Have keys as constants to prevent spelling errors
     * and avoid confusion. eg. "title" can be found in
     * ViewControllers too, so places can exist where the
     * particular string is used for something else.
     */
    static let kTaskLatKey = "lat"
    static let kTaskLngKey = "lng"
    
    let lat: Double
    let lng: Double
    let firebaseReference: DatabaseReference?
//    var completed: Bool
    
    /* Initializer for instantiating a new object in code.
     */
    init(lat: Double, lng: Double, completed: Bool, id: String = "") {
        self.lat = 1
        self.lng = 1
//        self.completed = completed
        self.firebaseReference = nil
    }
    
    /* Initializer for instantiating an object received from Firebase.
     */
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: Any]
        self.lat = snapshotValue[latLong.kTaskLatKey] as! Double
        self.lng = snapshotValue[latLong.kTaskLngKey] as! Double
        self.firebaseReference = snapshot.ref
    }
    
    /* Method to help updating values of an existing object.
     */
//    func toDictionary() -> Any {
//        return [
//            latLong.kTaskLatKey: self.lat,
//            latLong.kTaskLngKey: self.user,
//            Task.kTaskCompletedKey: self.completed
//        ]
//    }
}
