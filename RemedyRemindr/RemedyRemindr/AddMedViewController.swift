//
//  AddMedViewController.swift
//  RemedyRemindr
//
//  Created by Tony on 2015-02-08.
//  Copyright (c) 2015 Group 4. All rights reserved.
//

import UIKit
import CoreData

class AddMedViewController: UIViewController {

    @IBOutlet weak var medNameTextField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneButtonPressed(sender: AnyObject) {
        
        let newMed = Medication(name: medNameTextField.text)
        if let insertMed = MedicationDAO.insertMedication(newMed) {
            if insertMed {
                performSegueWithIdentifier("addButtonPressed", sender: sender)
            }
            else {
                var alert : UIAlertView = UIAlertView(title: "Medication Already Exists", message: "A medication with name " + newMed.name + " has already been added, please choose another name.", delegate: nil, cancelButtonTitle: "OK")
                alert.show()
            }
        } else {
            var alert : UIAlertView = UIAlertView(title: "Unexpected Error", message: "An unexpected error has occurred, please try again.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
    }
}
