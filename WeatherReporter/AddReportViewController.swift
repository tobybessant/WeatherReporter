//
//  AddReportViewController.swift
//  WeatherReporter
//
//  Created by (s) Toby Bessant on 19/03/2018.
//  Copyright © 2018 (s) Toby Bessant. All rights reserved.
//

import UIKit

class AddReportViewController: UIViewController {
    
    let dh = DataHandler()
    
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
    
    @IBAction func DoneButton(_ sender: Any)
    {
        unwrapAndSendInput()
    }
    
    func unwrapAndSendInput()
    {
        if let tempString = TemperatureTextInput.text, let temp = Int(tempString),
            let desc = DescriptionTextInput.text
        {
            dh.sendData(temp: temp, desc: desc)
            self.dismiss(animated: true, completion: nil)
        } else {
            alertView("ERROR", "Please enter valid data.")
        }
        
    }
    
    func alertView(_ title: String, _ msg: String) {
        
        let dialog = UIAlertController(title: title,
                                       message: msg,
                                       preferredStyle: UIAlertControllerStyle.alert)
        
        let okButtonOnAlertAction = UIAlertAction(title: "Dismiss", style: .default)
        { (action) -> Void in
            dialog.dismiss(animated: true, completion: nil)
        }
        
        dialog.addAction(okButtonOnAlertAction)
        
        self.present(dialog, animated: false, completion: nil)
    }}

