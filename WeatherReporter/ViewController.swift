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
//import FirebaseAuthUI
//import FirebaseGoogleAuthUI
import Firebase

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
    
    //var authUI: FUIAuth?
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    let locationManager = CLLocationManager()
    var location: CLLocationCoordinate2D?
    
    var dh: DataHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        if let appDelegate = appDelegate {
            appDelegate.viewController = self
        }
        
        dh = DataHandler(vc: self)
        
        map.delegate = self
        map.showsUserLocation = false
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self;
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    public func updateMapAnnotations() {
        for mapAnnotation in MapAnnotation.mapAnnotationsArray {
            let annotation = MKPointAnnotation()
            
            annotation.coordinate = CLLocationCoordinate2D.init(latitude: mapAnnotation.latitude, longitude: mapAnnotation.longitude)
            
            annotation.title = mapAnnotation.conditions
            annotation.subtitle = mapAnnotation.subtitle
            print(annotation)
            
            map.addAnnotation(annotation)
            
            print("annotation added")
        }
    }
    
    func getDatabaseData() {
        
        clearAnnotationsArray()
        clearAnnotationsFromMap()
        
        print("clearing data")
        print("getting data")
        
        if let dh = self.dh {
            dh.getAllDocuments()
            print("docs got")
        }
        
    }
    
    func clearAnnotationsFromMap() {
        let allAnnotations = self.map.annotations
        self.map.removeAnnotations(allAnnotations)
    }
    
    func clearAnnotationsArray() {
        MapAnnotation.mapAnnotationsArray.removeAll()
    }
    
    func lockSndStartTimer() {
        addButton.isEnabled = false
        let mainQueue = DispatchQueue.main
        let deadline = DispatchTime.now() + .seconds(10)
        mainQueue.asyncAfter(deadline: deadline) {
            print("ten seconds passed since data sent")
            self.addButton.isEnabled = true
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
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        //identifier for the dequeReusableAnnotationView
        let identifier = "MyPin"
        
        //the remaining code is unecessary if the user tapped their own location
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        
        //reuse the annotations in the same way tables reuse cells
        var annotationView: MKPinAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        //check for valid label and initialise the annotation view (white bubble thing that appears)
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
            //create the label and contents
            let label1 = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 25))
            if let text = annotation.subtitle {
                label1.text = text
                label1.font = label1.font.withSize(15)
            }
            
            label1.numberOfLines = 0 //removes lines restriction, will adjust depending on the content
            
            //add label to annotation view
            annotationView!.detailCalloutAccessoryView = label1
            
        } else {
            annotationView!.annotation = annotation
        }
        
        return annotationView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addSubmissionSegue" {
            
            if let navigationVC = segue.destination as? UINavigationController, let submissionVC = navigationVC.topViewController as? SubmissionInputTableViewController, let validLocation = self.location {
                submissionVC.location = validLocation
                submissionVC.mapView = self
            }
        }
    }

    @IBAction func unwindToMap(segue: UIStoryboardSegue) {
        
    }
    
    //@IBAction func signOutButtonPressed(_ sender: UIBarButtonItem) {
    //    do {
    //        try self.authUI?.signOut()
    //        showLoginScreen()
    //    } catch {
    //        print("Logout operation failed")
    //    }
    //}
}

