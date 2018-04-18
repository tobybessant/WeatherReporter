//
//  DataHandler.swift
//  WeatherReporter
//
//  Created by (s) Daniel Harris 1 on 18/04/2018.
//  Copyright © 2018 (s) Toby Bessant. All rights reserved.
//

import Foundation
import Firebase

public class DataHandler
{
    let db = Firestore.firestore()

    
    func sendData(temp: Int, desc: String)
    {
        var ref: DocumentReference? = nil
        ref = db.collection("test").addDocument(data:
            [
                "Date": generateDate(),
                "Description": desc,
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
        df.dateFormat = "dd.MM.yyyy"
        
        return df.string(from: date)
    }
    
}
