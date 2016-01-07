//
//  ViewController.swift
//  Prime-IT
//
//  Created by IT Mac on 12/29/15.
//  Copyright © 2015 IT Mac. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UITextViewDelegate {


    @IBOutlet weak var primeBackgroundView: UIView!
    @IBOutlet weak var primeTitleView: UIView!
    @IBOutlet weak var primeScrollView: UIScrollView!
    @IBOutlet weak var primeFieldView: UIView!
    @IBOutlet weak var primeStackView: UIStackView!
    @IBOutlet weak var primeLoadView: UIView!
    @IBOutlet weak var primeLoadingAct: UIActivityIndicatorView!
    
    @IBOutlet weak var problemField: MaterialTextField!
    @IBOutlet weak var barcodeField: MaterialTextField!
    @IBOutlet weak var firstNameField: MaterialTextField!
    @IBOutlet weak var lastNameField: MaterialTextField!
    @IBOutlet weak var commentView: UITextView!
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryPicker: UIPickerView!
    
    var kbHeight: CGFloat! = 0
    var activeTextField: UITextField!
    var activeTextView: UITextView!
    var viewActive: Bool! = true
    
//    var barcode: String!
//    var comment: String!
//    var category: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.categoryPicker.dataSource = self
        self.categoryPicker.delegate = self
        self.categoryPicker.hidden = true
        
        self.problemField.delegate = self
        self.barcodeField.delegate = self
        self.firstNameField.delegate = self
        self.lastNameField.delegate = self
        self.activeTextView = self.commentView
    
        commentView.delegate = self
        self.primeLoadView.hidden = true
        
        
//        print("background: \(primeBackgroundView.frame)")
//        print("titleview: \(primeTitleView.frame)")
//        print("scrollview: \(primeScrollView.frame)")
//        print("fieldview: \(primeFieldView.frame)")
//        print("stackview: \(primeStackView.frame)")
//        print("commentview: \(commentView.frame)")
//        print("\(viewActive)")

        
    }
    
    // ******** Move text field when keyboard show up ********
    func textFieldDidBeginEditing(textField: UITextField) {
//        print("field editing")
        self.viewActive = false
        self.activeTextField = textField
        
    }
    
//    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
//        print("this is called")
//        self.activeTextView = textView
//        return true
//    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func keyboardWillShow(notification: NSNotification){
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                self.kbHeight = keyboardSize.height
                let kbY = view.frame.height - kbHeight - self.primeScrollView.frame.minY - self.primeStackView.frame.minY - 5
//                print("\(kbY)")
//                print("kbHeight: \(kbHeight)")
                if self.viewActive == false {
                    if self.activeTextField.frame.maxY > kbY {
                        self.animateTextField(true)
                    } else {
                        self.animateTextField(false)
                    }
                } else {
//                    print("activeView: \(self.activeTextView.frame.maxY)")
                    if self.activeTextView.frame.maxY > kbY {
                        self.animateTextView(true)
                    } else {
                        self.animateTextView(false)
                    }
                }
            
                
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if self.viewActive == false {
            self.animateTextField(false)
            self.viewActive = true
        } else {
            self.animateTextView(false)
        }
        
    }
    
    func animateTextField(up: Bool) {
        
        let adjust = self.activeTextField.frame.maxY + self.primeScrollView.frame.minY + self.primeStackView.frame.minY - self.view.frame.height + self.kbHeight + 5
        let move = (up ? -adjust : 0)
        UIScrollView.animateWithDuration(0.3, animations: {
            self.primeFieldView.frame = CGRectOffset(self.view.frame, 0, move)
        })

    }
    
    func animateTextView(up: Bool) {
        
//        print("kbHeight: \(kbHeight)")
        let adjust = self.activeTextView.frame.maxY + self.primeScrollView.frame.minY + self.primeStackView.frame.minY - self.view.frame.height + self.kbHeight + 5
        let move = (up ? -adjust : 0)
        UIScrollView.animateWithDuration(0.3, animations: {
            self.primeFieldView.frame = CGRectOffset(self.view.frame, 0, move)
        })
        
    }
    // ******** End ********
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        scrollView.contentSize.width = 0
        
        if scrollView.contentOffset.x > 0 {
            scrollView.contentOffset.x = 0
        }
    }

    

    // ******** Actual form control ********
    
    @IBAction func submitPressed(sender: MaterialButton) {
        if self.problemField.text == "" {
            self.showErrorAlert("ALERT", msg: "Please describe your problem!")
        } else if self.firstNameField.text == "" || self.lastNameField.text == "" {
            self.showErrorAlert("ALERT", msg: "Your first name and last name are required!")
        } else {
            self.primeLoadView.hidden = false
            self.primeLoadingAct.startAnimating()
            let firstInitIndex = self.firstNameField.text!.startIndex.advancedBy(1)
            let firstInitial = self.firstNameField.text!.substringToIndex(firstInitIndex)
            let customerOrigin = self.lastNameField.text! + firstInitial
            let customer = customerOrigin.lowercaseString
            
            var ticket: Dictionary<String,String> = [
                "title": self.problemField.text!,
                "customer": customer,
                "condition": "Open"
            ]
            if self.barcodeField.text != "" {
                ticket["barcode"] = self.barcodeField.text
            }
            if self.categoryLabel.text != "" {
                ticket["category"] = self.categoryLabel.text
            }
            if self.commentView.text != "" {
                ticket["comments"] = self.commentView.text
            }
//            "barcode": self.barcode,
//            "category": self.categoryLabel.text!,
//            "comments": self.commentView.text!,
            
            
            let url = NSURL(string: TICKET_URL)
            
            Alamofire.request(.POST, url!, parameters: ticket, encoding: .JSON, headers: nil).response { request, response, data, error in
                
                //print("\(response)")
                if error == nil {
                    self.clearForm()
                    self.primeLoadView.hidden = true
                    self.primeLoadingAct.stopAnimating()
                    self.showErrorAlert("CONGRATULATION", msg: "Ticket is submitted successfully! We will work on it soon. Thank you for using IT ticket system!")
                } else {
                    self.primeLoadView.hidden = true
                    self.primeLoadingAct.stopAnimating()
                    self.showErrorAlert("ERROR", msg: "We are currently experiencing problem with receiving ticket! Please try again later.")
                }
            }
        }
    }
    
    @IBAction func clearPressed(sender: MaterialButton) {
        self.clearForm()
    }
    
    // ******** End Actual form control ********
    
    
    // ******** Picker View Config ********
    // Picker view initialization
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return CAT_PICKER_DATASOURCE.count;
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString! {
        let catData = CAT_PICKER_DATASOURCE[row]
        let catTitle = NSAttributedString(string: catData, attributes: [NSForegroundColorAttributeName: UIColor(red: 0xeb/255, green: 0xeb/255, blue: 0xeb/255, alpha: 1.0)])
        return catTitle
    }
    
    // Something is picked
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        self.categoryLabel.text = CAT_PICKER_DATASOURCE[row]
        
    }
    // ******** End Picker View Config ********
    
    // ******** Additional control ********
    
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
        self.categoryLabel.text = "Please pick a category."
        self.commentView.text = ""
        self.categoryPicker.hidden = true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

    
    
    // make sure it links to "touch down" event
    @IBAction func catTapped(sender: UITapGestureRecognizer) {
        self.categoryPicker.hidden = !self.categoryPicker.hidden
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

