//
//  ViewController.swift
//  Prime-IT
//
//  Created by IT Mac on 12/29/15.
//  Copyright © 2015 IT Mac. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var problemField: MaterialTextField!
    @IBOutlet weak var barcodeField: MaterialTextField!
    @IBOutlet weak var firstNameField: MaterialTextField!
    @IBOutlet weak var lastNameField: MaterialTextField!
    @IBOutlet weak var categoryField: MaterialTextField!
    @IBOutlet weak var commentField: MaterialTextField!
    
    @IBOutlet weak var categoryPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.categoryPicker.dataSource = self
        self.categoryPicker.delegate = self
        self.categoryPicker.hidden = true
        
    }

    // make sure it links to "touch down" event
    @IBAction func categoryChangeAction(sender: AnyObject) {
        self.categoryPicker.hidden = !self.categoryPicker.hidden
    }
    
    @IBAction func submitPressed(sender: MaterialButton) {
        if self.problemField.text == "" {
            self.showErrorAlert("ALERT", msg: "Please describe your problem!")
        } else {
            let firstInitIndex = self.firstNameField.text!.startIndex.advancedBy(1)
            let firstInitial = self.firstNameField.text!.substringToIndex(firstInitIndex)
            let customerOrigin = self.lastNameField.text! + firstInitial
            let customer = customerOrigin.lowercaseString
            
            let ticket: Dictionary<String,AnyObject> = [
                "title": self.problemField.text!,
                "customer": customer,
                "barcode": self.barcodeField.text!,
                "category": self.categoryField.text!,
                "comments": self.commentField.text!,
                "condition": "Open"
            ]
            let url = NSURL(string: TICKET_URL)
            
            Alamofire.request(.POST, url!, parameters: ticket, encoding: .JSON, headers: nil).response { request, response, data, error in
                if error == nil {
                    self.clearForm()
                    self.showErrorAlert("CONGRATULATION", msg: "Ticket is submitted successfully! We will work on it soon. Thank you for using IT ticket system!")
                } else {
                    self.showErrorAlert("ERROR", msg: "We are currently experiencing problem with receiving ticket! Please try again later.")
                }
            }
        }
    }
    
    @IBAction func clearPressed(sender: MaterialButton) {
        self.clearForm()
    }
    
    // Picker view initialization
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return CAT_PICKER_DATASOURCE.count;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return CAT_PICKER_DATASOURCE[row]
    }
    
    // Something is picked
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.categoryField.text = CAT_PICKER_DATASOURCE[row]
        
    }
    
    func showErrorAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func clearForm() {
        self.problemField.text = ""
        self.barcodeField.text = ""
        self.firstNameField.text = ""
        self.lastNameField.text = ""
        self.categoryField.text = ""
        self.commentField.text = ""
        self.categoryPicker.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

