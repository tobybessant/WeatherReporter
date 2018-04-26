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

class ViewController: UIViewController, MKMapViewDelegate, FUIAuthDelegate, CLLocationManagerDelegate {
    
    var authUI: FUIAuth?
    
    @IBOutlet weak var map: MKMapView!
    
    let locationManager = CLLocationManager()
    var location: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self
        
        let providers: [FUIAuthProvider] = [FUIGoogleAuth()]
        
        self.authUI?.providers = providers
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self;
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        
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
    
    func updateMapAnnotations() {
        for mapAnnotation in MapAnnotation.mapAnnotationsArray {
            let annotation = MKPointAnnotation()
            
            if let lat = Double(mapAnnotation.latitude), let lon = Double(mapAnnotation.longitude) {
                annotation.coordinate = CLLocationCoordinate2D.init(latitude: lat, longitude: lon)
            }
            
            annotation.title = mapAnnotation.conditions
            annotation.subtitle = String(mapAnnotation.temperature)
        }
    }
    
    func createAnnotations(date: String, time: String, conditions: String, windSpeed: String, windDirection: String, temperature: Int, longitude: String, latitude: String) {
        
        
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        if let err = error {
            print("Auth Error: \(err)")
        } else {
            print("Auth Success")
            self.dismiss(animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation:CLLocation = locations[0] as CLLocation
        
        manager.stopUpdatingLocation()
        
        let coordinations = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,longitude: userLocation.coordinate.longitude)
        let span = MKCoordinateSpanMake(0.2,0.2)
        let region = MKCoordinateRegion(center: coordinations, span: span)
        
        location = coordinations
        map.setRegion(region, animated: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addSubmissionSegue" {
            
            if let navigationVC = segue.destination as? UINavigationController, let submissionVC = navigationVC.topViewController as? SubmissionInputTableViewController, let validLocation = self.location {
                submissionVC.location = validLocation
            }
            
            
        }
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

