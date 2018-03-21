//
//  AddReportViewController.swift
//  WeatherReporter
//
//  Created by (s) Toby Bessant on 19/03/2018.
//  Copyright © 2018 (s) Toby Bessant. All rights reserved.
//

import UIKit

class AddReportViewController: UIViewController {
    
    var reportArray: [WeatherReport] = []
    
    @IBOutlet weak var TemperatureTextInput: UITextField!
    @IBOutlet weak var DescriptionTextInput: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
        @IBAction func DoneButton(_ sender: Any) {
        //Collect input information and store them in arrays
        // let tempTextInput = TemperatureTextInput.text ?? ""
        //let descrpitionTextInput = DescriptionTextInput.text ?? ""

        userInput()
            
    }
    //Gets input from the user and assigns the vaules into an Array
    func userInput(){
        
        if let temp = TemperatureTextInput.text{                                                //Assigns a temp to the input from the text field
            if let tempAsInt = Int(temp){                                                       //ensures that the temp veriable is of type Int
                if let desc = DescriptionTextInput.text{                                        //Assings a desc to the input from a text field
                    let wr = WeatherReport(temperature: tempAsInt, description: desc)           //Creates a new object from WeatherReport
                    reportArray.append(wr)                                                      //Adds to the report array list
                }
            }
        }
        for wr in reportArray{                                                                  //Prints out each element of the report Array
            print(wr)
        }
    }
}

