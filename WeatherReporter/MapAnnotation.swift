//
//  MapAnnotation.swift
//  WeatherReporter
//
//  Created by Toby on 26/04/2018.
//  Copyright © 2018 (s) Toby Bessant. All rights reserved.
//

import Foundation

struct MapAnnotation {
    var date: String
    var time: String
    var conditions: String
    var windSpeed: String
    var windDirection: String
    var temperature: Int
    var longitude: Double
    var latitude: Double
    
    static var mapAnnotationsArray: [MapAnnotation] = []
    
}
