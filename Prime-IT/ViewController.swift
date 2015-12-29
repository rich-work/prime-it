//
//  ViewController.swift
//  Prime-IT
//
//  Created by IT Mac on 12/29/15.
//  Copyright © 2015 IT Mac. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var problemField: MaterialTextField!
    @IBOutlet weak var barcodeField: MaterialTextField!
    @IBOutlet weak var firstNameField: MaterialTextField!
    @IBOutlet weak var lastNameField: MaterialTextField!
    @IBOutlet weak var categoryField: MaterialTextField!
    @IBOutlet weak var commentField: MaterialTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func submitPressed(sender: MaterialButton) {
        
    }
    
    @IBAction func clearPressed(sender: MaterialButton) {
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

