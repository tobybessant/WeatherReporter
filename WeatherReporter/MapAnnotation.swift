//
//  MapAnnotation.swift
//  WeatherReporter
//
//  Created by Toby on 26/04/2018.
//  Copyright © 2018 (s) Toby Bessant. All rights reserved.
//

import Foundation
import MapKit

class MapAnnotation: NSObject, MKAnnotation {
    
    //document id from firestore
    var id = ""
    
    //weather & location information
    var date: String = ""
    var time: String = ""
    var conditions: String = ""
    var windSpeed: String = ""
    var windDirection: String = ""
    var temperature: Int = 0
    var longitude: Double = 0.0
    var latitude: Double = 0.0
    
    //implementation for potential unique icons
    var icon: UIImage?
    
    //inherited from MKAnnotation - required for presenting information in the pins
    var title: String?
    var subtitle: String? {
        return "\(self.temperature)°C \n\(self.windSpeed)mph (\(self.windDirection)) \n\(self.date) at \(self.time)"
    }
    var coordinate: CLLocationCoordinate2D
    
    //init that assigns parameters to properties
    init(id: String, date: String, time: String, conds: String, windSpd: String, windDir: String, temperature: Int, longitude: Double, latitude: Double) {
        
        self.date = date
        self.time = time
        self.conditions = conds
        self.windSpeed = windSpd
        self.windDirection = windDir
        self.temperature = temperature
        self.longitude = longitude
        self.latitude = latitude
        
        self.title = self.conditions
        self.coordinate = CLLocationCoordinate2DMake(self.longitude, self.latitude)
        
    }
    
    //static array of MapAnnotation's for loca storage and ease of pin-information presentation
    static var mapAnnotationsArray: [MapAnnotation] = []
    
    //partial function implmentation to change the pin icon depending on what the weather conditions string reads. i.e. if 'Sunny', icon will return a sun icon.
     func getIcon() -> UIImage? {
        guard let icon = UIImage(named: "test_pin_icon") else  { return nil }
    
        return icon
        
    }
}
