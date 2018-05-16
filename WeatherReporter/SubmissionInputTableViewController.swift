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

    @IBOutlet weak var conditionsTypeLabel: UILabel!
    @IBOutlet weak var conditionsPickerView: UIPickerView!
    @IBOutlet weak var temperatureTextInput: UITextField!
    @IBOutlet weak var windSpeedTextInput: UITextField!
    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var directionPickerView: UIPickerView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    var selectedDirection = ""
    var selectedCondition = ""
    
    var conditions = ["Sunny","Rainy","Overcast", "Snowy"]
    var directions = ["North","East","South","West"
    ]
    let conditionsPickerViewCellIndexPath = IndexPath(row: 1, section: 0)
    let directionsPickerViewCellIndexPath = IndexPath(row:2, section: 2)
    
    var location: CLLocationCoordinate2D?
    
    var mapView: ViewController?
    
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
        
        updateDoneButtonState()
        
        conditionsPickerView.tag = 0
        directionPickerView.tag = 1
        
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

    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        print(indexPath)
        
        if (indexPath.section == conditionsPickerViewCellIndexPath.section) && (indexPath.row == conditionsPickerViewCellIndexPath.row - 1) {
            
            self.view.endEditing(true)
            
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
        
        if (indexPath.section == directionsPickerViewCellIndexPath.section) && (indexPath.row == directionsPickerViewCellIndexPath.row - 1) {
            
            self.view.endEditing(true)
            
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
    
    func unwrapAndSendInput() {
        print("USI")
        
        var dh: DataHandler? = nil
        
        if let mv = mapView {
            dh = DataHandler(vc: mv)
        }
        
        
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
    
    func updateDoneButtonState() {
        let temperature = temperatureTextInput.text ?? ""
        let windSpeed = windSpeedTextInput.text ?? ""
        let windDirection = directionLabel.text ?? ""
        
        doneButton.isEnabled = !temperature.isEmpty && !windSpeed.isEmpty && !windDirection.isEmpty && !(conditionsTypeLabel.text == "Select Type...") && !(directionLabel.text == "Select Direction...")
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0 {
            //conditionsTypeLabel.text = conditions[row]
            selectedCondition = conditions[row]
        } else if pickerView.tag == 1 {
            //directionLabel.text = directions[row]
            selectedDirection = directions[row]
        }
        updateDoneButtonState()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0 {
            return conditions.count
        } else if pickerView.tag == 1 {
            return directions.count
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView.tag == 0 {
            return conditions[row]
        } else if pickerView.tag == 1 {
            return directions[row]
        }
        return ""
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



