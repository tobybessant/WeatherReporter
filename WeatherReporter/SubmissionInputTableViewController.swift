//
//  SubmissionInputTableViewController.swift
//  WeatherReporter
//
//  Created by (s) Toby Bessant on 25/04/2018.
//  Copyright © 2018 (s) Toby Bessant. All rights reserved.
//

import UIKit
import CoreLocation

class SubmissionInputTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var conditionsTypeLabel: UILabel!
    @IBOutlet weak var conditionsPickerView: UIPickerView!
    @IBOutlet weak var temperatureTextInput: UITextField!
    @IBOutlet weak var windSpeedTextInput: UITextField!
    @IBOutlet weak var windDirectionTextInput: UITextField!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    var conditions = ["Sunny","Rainy","Overcast"]
    
    let conditionsPickerViewCellIndexPath = IndexPath(row: 1, section: 0)
    
    var location: CLLocationCoordinate2D?
    
    var isConditionsPickerShown: Bool = false {
        didSet{
            conditionsPickerView.isHidden = !isConditionsPickerShown
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        updateDoneButtonState()
        conditionsPickerView.delegate = self
        conditionsPickerView.dataSource = self
        
        tableView.beginUpdates()
        tableView.endUpdates()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        print(indexPath)
        
        if (indexPath.section == conditionsPickerViewCellIndexPath.section) && (indexPath.row == conditionsPickerViewCellIndexPath.row - 1) {
            
            if isConditionsPickerShown {
                isConditionsPickerShown = false
            } else {
                isConditionsPickerShown = true
            }
           
        } else {
            isConditionsPickerShown = false
        }
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.section, indexPath.row) {
        case (conditionsPickerViewCellIndexPath.section, conditionsPickerViewCellIndexPath.row):
            if isConditionsPickerShown {
                return 160.0
            } else {
                return 0
            }
        default:
            return 44.0
        }
    }
    
    func unwrapAndSendInput() {
        let dh = DataHandler()
        
        if let conditions = conditionsTypeLabel.text,
            let tempString = temperatureTextInput.text,
            let temp = Int(tempString),
            let windSpeed = windSpeedTextInput.text,
            let windDirection = windDirectionTextInput.text,
            let validLocation = location
        {
            dh.sendData(conditions: conditions, temp: temp, windSpeed: windSpeed, windDirection: windDirection, location: validLocation)
        } else {
            alertView("ERROR", "Please enter valid information.")
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
    }
    
    func updateDoneButtonState(){
        let temperature = temperatureTextInput.text ?? ""
        let windSpeed = windSpeedTextInput.text ?? ""
        let windDirection = windDirectionTextInput.text ?? ""
        
        doneButton.isEnabled = !temperature.isEmpty && !windSpeed.isEmpty && !windDirection.isEmpty && !(conditionsTypeLabel.text == "Select Type...")
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        conditionsTypeLabel.text = conditions[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return conditions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return conditions[row]
    }
    
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateDoneButtonState()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard segue.identifier == "saveUnwind" else { return }
        
        unwrapAndSendInput()
        
    }
    
}



