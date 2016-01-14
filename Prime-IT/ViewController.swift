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
    
    @IBOutlet weak var problemField: MaterialTextField!
    @IBOutlet weak var barcodeField: MaterialTextField!
    @IBOutlet weak var firstNameField: MaterialTextField!
    @IBOutlet weak var lastNameField: MaterialTextField!
    @IBOutlet weak var commentView: UITextView!
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryPicker: UIPickerView!
    
    var ticketToSubmit: Ticket!
    
    var kbHeight: CGFloat! = 0
    var activeTextField: UITextField!
    var activeTextView: UITextView!
    var viewActive: Bool! = true
    
    var loading: UIAlertController!
    var activity: UIActivityIndicatorView!
    
//    var barcode: String!
//    var comment: String!
//    var category: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.categoryPicker.dataSource = self
        self.categoryPicker.delegate = self
        self.categoryPicker.hidden = true
        self.ticketToSubmit = Ticket(t: "", fn: "", ln: "", bcode: "", cat: "", com: "")
        
        self.problemField.delegate = self
        self.barcodeField.delegate = self
        self.firstNameField.delegate = self
        self.lastNameField.delegate = self
        self.activeTextView = self.commentView
    
        commentView.delegate = self
        
        
//        print("background: \(primeBackgroundView.frame)")
//        print("titleview: \(primeTitleView.frame)")
//        print("scrollview: \(primeScrollView.frame)")
//        print("fieldview: \(primeFieldView.frame)")
//        print("stackview: \(primeStackView.frame)")
//        print("commentview: \(commentView.frame)")
//        print("\(viewActive)")

        
    }
    

    // ******** Actual form control ********
    
    @IBAction func submitPressed(sender: MaterialButton) {

        self.showLoading()
        if self.problemField.text == "" {
            self.showErrorAlert("ALERT", msg: "Please describe your problem!")
        } else if self.firstNameField.text == "" || self.lastNameField.text == "" {
            self.showErrorAlert("ALERT", msg: "Your first name and last name are required!")
        } else if self.barcodeField.text != "" {
            
            self.verifyBarcode { (flg) in
                if flg == true {
//                    self.showLoading()
                    self.ticketToSubmit = Ticket(t: self.problemField.text!, fn: self.firstNameField.text!, ln: self.lastNameField.text!, bcode: self.barcodeField.text!, cat: self.categoryLabel.text!, com: self.commentView.text!)
                    self.verifyUserNSubmit()
                }
            }
        } else {
//            self.showLoading()
            self.ticketToSubmit = Ticket(t: self.problemField.text!, fn: self.firstNameField.text!, ln: self.lastNameField.text!, bcode: self.barcodeField.text!, cat: self.categoryLabel.text!, com: self.commentView.text!)
            self.verifyUserNSubmit()
        }

    }
    
    @IBAction func clearPressed(sender: MaterialButton) {
        self.clearForm()
    }
    
    // ******** End Actual form control ********

    
    
    func verifyBarcode(completionHandler: (Bool?) -> ()) {

        let urlEquipStr = URL_EQUIPMENT + "\(self.barcodeField.text!)"
        let urlEquip = NSURL(string: urlEquipStr)!
        
        Alamofire.request(.GET, urlEquip).validate().responseJSON { response in

            if response.response!.statusCode == 200 {
                if let res = response.result.value as? Int {
                    if res > 0 {
                        completionHandler(true)
                    } else {
                        self.showErrorAlert("ERROR", msg: "Invalid Barcode!")
                        completionHandler(false)
                    }
                }
            } else {
                self.showErrorAlert("ERROR", msg: "Invalid Barcode!")
                completionHandler(false)
            }
            
        }
    }
    
    func verifyUserNSubmit() {
        let urlStr = URL_USER + "\(ticketToSubmit.firstName)" + "/" + "\(ticketToSubmit.lastName)"
        let urlUser = NSURL(string: urlStr)!
        
        Alamofire.request(.GET, urlUser).responseJSON { response in

            if let resultJSON = response.result.value as? [Dictionary<String,AnyObject>] {
                if resultJSON.count > 1 {
                    for var i = 0; i < resultJSON.count; ++i {
                        if let userName = resultJSON[i]["username"] as? String {
                            self.ticketToSubmit.addAvailUserName(userName)
                        }
                    }
                    
                    print(self.ticketToSubmit.availUser)
                    self.showOptions()
                    
                } else if resultJSON.count == 1 {
                    if let userName = resultJSON[0]["username"] as? String {
                        self.ticketToSubmit.assignUserName(userName)
                        self.submitTicket()
                    }
                    print("submit ticket: " + self.ticketToSubmit.customer)
                } else {
                    self.showErrorAlert("ERROR", msg: "No user found! Please check the spelling of your name or contact IT.")
                }
            }
        }
    }
    
    // ******** Submit Ticket **********
    
    func submitTicket() {
//        self.showLoading()
        var ticket: Dictionary<String,String> = [
            "title": self.ticketToSubmit.title,
            "customer": self.ticketToSubmit.customer,
            "condition": "Open"
        ]
        if self.ticketToSubmit.barcode != "" {
            ticket["barcode"] = self.ticketToSubmit.barcode
        }
        if self.ticketToSubmit.category != "" && self.ticketToSubmit.category != "Please pick a category." {
            ticket["category"] = self.ticketToSubmit.category
        }
        if self.ticketToSubmit.comment != "" {
            ticket["comments"] = self.ticketToSubmit.comment
        }

        let url = NSURL(string: TICKET_URL)
        
        Alamofire.request(.POST, url!, parameters: ticket, encoding: .JSON, headers: nil).responseJSON { response in

            if response.response!.statusCode == 200 {
                self.clearForm()
                self.showSuccessAlert("CONGRATULATION", msg: "Ticket is submitted successfully! We will work on it soon. Thank you for using IT ticket system!")
//                self.viewDidLoad()
            } else {
                self.showErrorAlert("ERROR", msg: "We are currently experiencing problem with receiving ticket! Please try again later.")
            }
        }
        
    }
    
    // ******** End Submit Ticket **********
    
    
    // ******** Additional control ********
    
    
    // ******** Action sheet ********
    
    func showOptions() {
        self.activity.stopAnimating()
        self.presentedViewController?.dismissViewControllerAnimated(true, completion: nil)
        let actionSheet = UIAlertController(title: "ALERT", message: "Multiple users associated with this name. Please choose your user ID:", preferredStyle: .ActionSheet)
        let dismissChoice = {
            (action: UIAlertAction!) -> Void in
            self.ticketToSubmit.assignUserName(action.title!)
            self.submitTicket()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        for var j = 0; j < self.ticketToSubmit.availUser.count; j++ {
            actionSheet.addAction(UIAlertAction(title: self.ticketToSubmit.availUser[j], style: .Default, handler: dismissChoice))
        }
        actionSheet.addAction(UIAlertAction(title: "CANCEL", style: .Destructive, handler: nil))
        presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    // ******** End of Action Sheet ********
    
    func showLoading() {
        
        self.loading = UIAlertController(title: "Connecting...", message: "\n\n", preferredStyle: .Alert)
        self.activity = UIActivityIndicatorView(frame: self.loading.view.bounds)
        self.activity.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.activity.color = UIColor.blackColor()
        self.loading.view.addSubview(self.activity)
        self.activity.userInteractionEnabled = false
        self.activity.startAnimating()
        self.presentViewController(self.loading, animated: true, completion: nil)
        
    }
    
    func showErrorAlert(title: String, msg: String) {
        self.activity.stopAnimating()
        self.presentedViewController?.dismissViewControllerAnimated(true, completion: nil)
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func showSuccessAlert(title: String, msg: String) {
        self.activity.stopAnimating()
        self.presentedViewController?.dismissViewControllerAnimated(true, completion: nil)
        let success = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let dismissAction = {
            (action: UIAlertAction!) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
            self.viewDidLoad()
        }
        let action = UIAlertAction(title: "OK", style: .Default, handler: dismissAction)
        success.addAction(action)
        presentViewController(success, animated: true, completion: nil)
    }
    
    func clearForm() {
        self.problemField.text = ""
        self.barcodeField.text = ""
        self.firstNameField.text = ""
        self.lastNameField.text = ""
        self.categoryLabel.text = "Please pick a category."
        self.commentView.text = ""
        self.categoryPicker.hidden = true
        self.ticketToSubmit.resetTicket()
        self.viewDidLoad()
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

    
    // ******** Picker View Config ********
    // Picker view initialization
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return CAT_PICKER_DATASOURCE.count;
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let catData = CAT_PICKER_DATASOURCE[row]
        let catTitle = NSAttributedString(string: catData, attributes: [NSForegroundColorAttributeName: UIColor(red: 0xeb/255, green: 0xeb/255, blue: 0xeb/255, alpha: 1.0)])
        return catTitle
    }
    
    // Something is picked
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.categoryLabel.text = CAT_PICKER_DATASOURCE[row]
        
    }
    // ******** End Picker View Config ********
    
    
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
    

    
    // make sure it links to "touch down" event
    @IBAction func catTapped(sender: UITapGestureRecognizer) {
        self.categoryPicker.hidden = !self.categoryPicker.hidden
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

