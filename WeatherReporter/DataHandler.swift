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

public class DataHandler
{
    let db = Firestore.firestore()
    
    func sendData(conditions: String, temp: Int, windSpeed: String, windDirection: String)
    {
        var ref: DocumentReference? = nil
        ref = db.collection("WeatherSubmissions").addDocument(data:[
                "Date": generateDate(),
                "Time": generateTime(),
                "Conditions": conditions,
                "Wind Speed": windSpeed,
                "Wind Direction": windDirection,
                "Temperature": temp,
                ]) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                        
                    } else {
                        print("Document added with ID: \(ref!.documentID)")
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
