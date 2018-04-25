//
//  SubmissionInputTableViewController.swift
//  WeatherReporter
//
//  Created by (s) Toby Bessant on 25/04/2018.
//  Copyright © 2018 (s) Toby Bessant. All rights reserved.
//

import UIKit

class SubmissionInputTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var conditionsTypeLabel: UILabel!
    @IBOutlet weak var conditionsPickerView: UIPickerView!
    @IBOutlet weak var temperatureTextInput: UITextField!
    @IBOutlet weak var windSpeedTextInput: UITextField!
    @IBOutlet weak var windDirectionTextInput: UITextField!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    var conditions = ["Sunny","Rainy","Overcast"]
    
    let conditionsPickerViewCellIndexPath = IndexPath(row: 1, section: 0)
    
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

    // MARK: - Table view data source

    //override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
    //}

    //override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //}

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    let dh = DataHandler()
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
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
    
    func unwrapAndSendInput()
    {
        if let conditions = conditionsTypeLabel.text, let tempString = temperatureTextInput.text, let temp = Int(tempString),
            let windSpeed = windSpeedTextInput.text, let windDirection = windDirectionTextInput.text
        {
            dh.sendData(conditions: conditions, temp: temp, windSpeed: windSpeed, windDirection: windDirection)
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
        
        guard segue.identifier == "doneUnwind" else { return }
        
        unwrapAndSendInput()
        
    }
    
}



