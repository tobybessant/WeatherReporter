//
//  DataHandler.swift
//  WeatherReporter
//
//  Created by (s) Daniel Harris 1 on 18/04/2018.
//  Copyright © 2018 (s) Toby Bessant. All rights reserved.
//

import Foundation
import Firebase
import UIKit
import CoreLocation

public class DataHandler
{
    let db = Firestore.firestore()
    
    func sendData(conditions: String, temp: Int, windSpeed: String, windDirection: String, location: CLLocationCoordinate2D)
    {
        var ref: DocumentReference? = nil
        ref = db.collection("WeatherSubmissions").addDocument(data:[
                "Date": generateDate(),
                "Time": generateTime(),
                "Conditions": conditions,
                "Wind Speed": windSpeed,
                "Wind Direction": windDirection,
                "Temperature": temp,
                "Longitude": location.longitude,
                "Latitude": location.latitude
                ]) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                        
                    } else {
                        print("Document added with ID: \(ref!.documentID)")
                    }
        }
    }
    
    func getAllDocuments()
    {
        db.collection("WeatherSubmissions").getDocuments() {(querySnapshot, err) in
            if let err = err
            {
                print("Error Getting Documents: \(err)")
                
            } else {
                for document in querySnapshot!.documents
                {
                    if let date:String = document.get("Date") as? String,
                        let time = document.get("Time") as? String,
                        let conditions = document.get("Conditions") as? String,
                        let windSpeed = document.get("Wind Speed") as? String,
                        let windDirection = document.get("Wind Direction") as? String,
                        let temperature = document.get("Temperature") as? Int,
                        let longitude = document.get("Longitude") as? Double,
                        let latitude = document.get("Latitude") as? Double {
                        
                        let newMapAnnotation = MapAnnotation(date: date, time: time, conditions: conditions, windSpeed: windSpeed, windDirection: windDirection, temperature: temperature, longitude: longitude, latitude: latitude)
                        
                        MapAnnotation.mapAnnotationsArray.append(newMapAnnotation)
                        
                    }
                    
                    
                }
            }
            
        }
    }
    
    func generateDate() -> String
    {
        let date = Date()
        let df = DateFormatter()
        df.dateStyle = .short

        return df.string(from: date)
    }
    
    func generateTime() -> String
    {
        let date = Date()
        let df = DateFormatter()
        df.dateStyle = .none
        df.timeStyle = .short
        
        return df.string(from: date)
    }
    
   
}
