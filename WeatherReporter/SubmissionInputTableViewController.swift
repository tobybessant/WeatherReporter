//
//  SubmissionInputTableViewController.swift
//  WeatherReporter
//
//  Created by (s) Toby Bessant on 25/04/2018.
//  Copyright © 2018 (s) Toby Bessant. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class SubmissionInputTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    //outlets to labels
    @IBOutlet weak var conditionsTypeLabel: UILabel!
    @IBOutlet weak var conditionsPickerView: UIPickerView!
    @IBOutlet weak var temperatureTextInput: UITextField!
    @IBOutlet weak var windSpeedTextInput: UITextField!
    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var directionPickerView: UIPickerView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    //
    var selectedDirection = ""
    var selectedCondition = ""
    
    //picker view setup - 'enum' arrays and index paths to their cells for dynamic sizing
    var conditions = ["☀️ Sunny", "☁️ Overcast", "💨 Windy", "☔️ Rainy", "⚡️ Thundery","❄️ Snowy" ]
    var directions = ["↑ North","→ East","↓ South","→ West"]
    
    let conditionsPickerViewCellIndexPath = IndexPath(row: 1, section: 0)
    let directionsPickerViewCellIndexPath = IndexPath(row:2, section: 2)
    
    //location and map refs parsed from prepare segue of ViewController
    var location: CLLocationCoordinate2D?
    
    var mapView: ViewController?
    
    //computed properties to indicate the picker view being shown or hidden
    var isDirectionsPickerShown: Bool = false {
        didSet {
            directionPickerView.isHidden = !isDirectionsPickerShown
        }
    }
    
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
        
        //disable button until all inputs are valid.
        updateDoneButtonState()
        
        //tag pickerviews so they can be referenced later in code
        conditionsPickerView.tag = 0
        directionPickerView.tag = 1
        
        //assign picker view delegates to this view controller.
        conditionsPickerView.delegate = self
        conditionsPickerView.dataSource = self
        directionPickerView.delegate = self
        directionPickerView.dataSource = self
        
        tableView.beginUpdates()
        tableView.endUpdates()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //code to update the picker view label text.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        //if the user taps the cell above the picker view cell, change text to read 'Select', otherwise change to read the users selection.
        if (indexPath.section == conditionsPickerViewCellIndexPath.section) && (indexPath.row == conditionsPickerViewCellIndexPath.row - 1) {
            
            self.view.endEditing(true) //dismiss keyboard if its open from user editing previous field
            
            if isConditionsPickerShown {
                isConditionsPickerShown = false
                conditionsTypeLabel.textColor = .black
                conditionsTypeLabel.text = selectedCondition
                
            } else {
                isConditionsPickerShown = true
                conditionsTypeLabel.textColor = .blue
                conditionsTypeLabel.text = "Select"
            }
           
        } else {
            isConditionsPickerShown = false
        }
        
        //if the user taps the cell above the picker view cell, change text to read 'Select', otherwise change to read the users selection.
        if (indexPath.section == directionsPickerViewCellIndexPath.section) && (indexPath.row == directionsPickerViewCellIndexPath.row - 1) {
            
            self.view.endEditing(true) //dismiss keyboard if its open from user editing previous field
            
            if isDirectionsPickerShown {
                isDirectionsPickerShown = false
                directionLabel.textColor = .black
                directionLabel.text = selectedDirection
            } else {
                isDirectionsPickerShown = true
                directionLabel.textColor = .blue
                directionLabel.text = "Select"
            }
        } else {
            isDirectionsPickerShown = false
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    //code to manage the dynamic changing of pickerview cell height to give a show/hide effect.
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.section, indexPath.row) {
        case (conditionsPickerViewCellIndexPath.section, conditionsPickerViewCellIndexPath.row):
            if isConditionsPickerShown {
                return 160.0
            } else {
                return 0
            }
        case (directionsPickerViewCellIndexPath.section, directionsPickerViewCellIndexPath.row):
            if isDirectionsPickerShown {
                return 160.0
            } else {
                return 0
            }
        default:
            return 44.0
        }
    }
    
    //unwraps the users input as a final measure against sending invalid input, and uses the datahandler to send it to the database.
    func unwrapAndSendInput() {
        var dh: DataHandler?
        if let mv = mapView {
            dh = DataHandler(vc: mv)
            
            if let conditions = conditionsTypeLabel.text,
                let tempString = temperatureTextInput.text,
                let temp = Int(tempString),
                let windSpeed = windSpeedTextInput.text,
                let windDirection = directionLabel.text,
                let validLocation = location {
                
                if let datahandler = dh {
                    datahandler.sendData(conditions: conditions, temp: temp, windSpeed: windSpeed, windDirection: windDirection, location: validLocation)
                }
            }
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
    
    //method is called whenever input fields are updated, or picker views are tapped. Checks the validity of inputs so it can enable the 'Done' button.
    func updateDoneButtonState() {
        let temperature = temperatureTextInput.text ?? ""
        let windSpeed = windSpeedTextInput.text ?? ""
        let windDirection = directionLabel.text ?? ""
        
        doneButton.isEnabled = !temperature.isEmpty && !windSpeed.isEmpty &&
            !windDirection.isEmpty &&
            !((conditionsTypeLabel.text == "Select Type...") || (conditionsTypeLabel.text == "Select") || (conditionsTypeLabel.text == "")) &&
            !((directionLabel.text == "Select Direction...") || (conditionsTypeLabel.text == "Select") || (directionLabel.text == ""))
    }
    
    //update selected picker values to later update the picker view labels when the user has closed the picker views.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0 {
            selectedCondition = conditions[row]
        } else if pickerView.tag == 1 {
            selectedDirection = directions[row]
        }
        updateDoneButtonState()
    }
    
    //picker view setup: number of columns
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //picker view setup: number of rows/items
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0 {
            return conditions.count
        } else if pickerView.tag == 1 {
            return directions.count
        }
        return 1
    }
    
    //picker view setup: name of each row/item
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView.tag == 0 {
            return conditions[row]
        } else if pickerView.tag == 1 {
            return directions[row]
        }
        return ""
    }
    
    //ibaction that is called whenever the text in a field is edited - both fields are connected to this aciton.
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateDoneButtonState()
    }
    
    //if user taps done button (which will need to have been enabled by their valid input), unwind to the map, and send their inputted data.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard segue.identifier == "saveUnwind" else { return }
        
        unwrapAndSendInput()
        
    }
    
}



