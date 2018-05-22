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
    
    //outlets to the mapview and '+' button
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    //variables for location management + storing
    let locationManager = CLLocationManager()
    var location: CLLocationCoordinate2D?
    
    //datahandler object for firestore interactions
    var dh: DataHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        if let appDelegate = appDelegate {
            appDelegate.viewController = self
        }
        
        //initialise datahandler, parsing this viewcontroller so that map functions can be used
        dh = DataHandler(vc: self)
        
        //map delegates and settings
        map.delegate = self
        map.showsUserLocation = false
        locationManager.requestWhenInUseAuthorization()
        //start tracking users location
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self;
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            map.userTrackingMode = .follow
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    //loop through MappAnnotation array and create annotation objects of them all - assigning title and subtitle values.
    public func updateMapAnnotations() {
        for mapAnnotation in MapAnnotation.mapAnnotationsArray {
            let annotation = MKPointAnnotation()
            
            annotation.coordinate = CLLocationCoordinate2D.init(latitude: mapAnnotation.latitude, longitude: mapAnnotation.longitude)
            
            annotation.title = mapAnnotation.conditions
            annotation.subtitle = mapAnnotation.subtitle
            print(annotation)
            
            map.addAnnotation(annotation)
            
        }
    }
    
    //clear all info in MapAnnotation array and get all records from firestore via the DataHandler object.
    func getDatabaseData() {
        
        clearAnnotationsFromMap() //clear map
        clearAnnotationsArray() //clear array
        
        if let dh = self.dh {
            //fetch all firebase records and update MapAnnotation array  + subsequently the map annotations
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
    
    //disable the '+' button for 30s after user has successfully submitted information, to prevent spam.
    func lockButtonAndStartTimer() {
        addButton.isEnabled = false
        let mainQueue = DispatchQueue.main
        let deadline = DispatchTime.now() + .seconds(30)
        mainQueue.asyncAfter(deadline: deadline) {
            print("ten seconds passed since data sent")
            self.addButton.isEnabled = true
        }
    }
    
    //delegate method called everytime the users location is updated.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation:CLLocation = locations[0] as CLLocation //get most recent location update
        
        manager.stopUpdatingLocation() //stop updating to save resources
        
        //break down information into components
        let coordinations = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,longitude: userLocation.coordinate.longitude)
        let span = MKCoordinateSpanMake(0.2,0.2)
        let region = MKCoordinateRegion(center: coordinations, span: span)
        
        location = coordinations //update variable with value
        map.setRegion(region, animated: true) //make map zoom in on users location
        
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
    
    //sends data from map view, as well as the viewcontroller itself.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addSubmissionSegue" {
            
            if let navigationVC = segue.destination as? UINavigationController {
                print("valid navVC")
                if let submissionVC = navigationVC.topViewController as? SubmissionInputTableViewController {
                    print("valid subVC")
                    if let validLocation = self.location {
                        submissionVC.location = validLocation
                        submissionVC.mapView = self
                        print("sent data")
                    }
                    print("invalid location")
                }
                
            }
        }
    }

    @IBAction func unwindToMap(segue: UIStoryboardSegue) {
        
    }
}

