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
    
    var date: String = ""
    var time: String = ""
    var conditions: String = ""
    var windSpeed: String = ""
    var windDirection: String = ""
    var temperature: Int = 0
    var longitude: Double = 0.0
    var latitude: Double = 0.0
    
    var title: String?
    var subtitle: String? {
        return "\(self.temperature)°C \n Wind: \(self.windSpeed), \(self.windDirection) \n \(self.date) at \(self.time)"
    }
    var coordinate: CLLocationCoordinate2D
    
    init(date: String, time: String, conds: String, windSpd: String, windDir: String, temperature: Int, longitude: Double, latitude: Double) {
        
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
    
    static var mapAnnotationsArray: [MapAnnotation] = []
    
}
