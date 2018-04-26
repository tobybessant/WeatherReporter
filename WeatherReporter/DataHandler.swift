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
    let settings: FirestoreSettings
    
    init() {
        settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
    }
    
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
    func getAllDocuments(closure: (_ date: String, _ time: String, _ conditions: String, _ windSpeed: String, _ windDirection: String, _ temperature: Int, _ longitude: String, _ latitude: String) -> Void)
    {
        db.collection("WeatherSubmissions").getDocuments() {(querySnapshot, err) in
            if let err = err
            {
                print("Error Getting Documents: \(err)")
                
            } else {
                for document in querySnapshot!.documents
                {
                    print("\(document.documentID) => \(document.data())")
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
