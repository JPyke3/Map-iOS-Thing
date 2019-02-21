//
//  AppDelegate + GoogleSignIn.swift
//  TSpooon
//
//  Created by Jacob Pyke on 23.01.19.
//  Copyright © 2019 Pykee Co. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import GoogleSignIn

var currentUser: User?

extension AppDelegate : GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            // ...
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                // ...
                return
            }
            // User is signed in
            print("Succesfully  Authenticated Via Google!")
            currentUser = Auth.auth().currentUser
            (self.window?.rootViewController as? ViewController)?.userAuthenticated()
            
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("Schade! A disconnect!")
    }
}
