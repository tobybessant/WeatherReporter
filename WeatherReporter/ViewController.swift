//
//  ViewController.swift
//  WeatherReporter
//
//  Created by (s) Toby Bessant on 19/03/2018.
//  Copyright © 2018 (s) Toby Bessant. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import FirebaseAuthUI
import FirebaseGoogleAuthUI

class ViewController: UIViewController, MKMapViewDelegate, FUIAuthDelegate {
    
    var authUI: FUIAuth?
    
    @IBOutlet weak var map: MKMapView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self
        
        let providers: [FUIAuthProvider] = [FUIGoogleAuth()]
        
        self.authUI?.providers = providers
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showLoginScreen()
    }
    
    private func isUserSignedIn() -> Bool {
        if Auth.auth().currentUser == nil {return false}
        return true
    }
    
    private func showLoginScreen() {
        if !isUserSignedIn() {
            let authViewController = authUI!.authViewController()
            self.present(authViewController, animated: true)
        }
        
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        if let err = error {
            print("Auth Error: \(err)")
        } else {
            print("Auth Success")
            self.dismiss(animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToMap(segue: UIStoryboardSegue) {
        
    }

    @IBAction func signOutButtonPressed(_ sender: UIBarButtonItem) {
        do {
            try self.authUI?.signOut()
            showLoginScreen()
        } catch {
            print("Logout operation failed")
        }
    }
}

