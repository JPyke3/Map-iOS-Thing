//
//  ViewController.swift
//  TSpooon
//
//  Created by Jacob Pyke on 23.01.19.
//  Copyright © 2019 Pykee Co. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn
import AVFoundation
import AVKit
import MaterialComponents.MaterialTextFields

class ViewController: UIViewController, GIDSignInUIDelegate {
    
    @IBOutlet weak var signUpConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadConstraints()
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    @IBAction func signUpPressed(_ sender: Any) {
        signUpConstraint.constant = 5
//        loginConstraint.constant = -350
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        signUpConstraint.constant = -1 * self.view.frame.size.width
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        loginConstraint.constant = 5
//        signUpConstraint.constant = -500
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @IBAction func loginBackButtonPressed(_ sender: Any) {
        loginConstraint.constant = -1 * self.view.frame.size.width
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    
    func loadConstraints() {
        loginConstraint.constant = -1 * self.view.frame.size.width
        signUpConstraint.constant = -1 * self.view.frame.size.width
    }
    
//    GIDSignIn.sharedInstance().signIn()
    
    func userAuthenticated() {
        performSegue(withIdentifier: "loginToMenu", sender: self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}

