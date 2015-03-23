//
//  AddMedViewController.swift
//  RemedyRemindr
//
//  Created by RemedyRemindr Team on 2015-02-08.
//  Copyright (c) 2015 Group 4. All rights reserved.
//

import UIKit
import CoreData

class AddMedViewController: UIViewController, UITextFieldDelegate {

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
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    @IBAction func doneButtonPressed(sender: AnyObject) {
        
        let whiteSpace = NSCharacterSet.whitespaceCharacterSet()
        let medicationText = medNameTextField.text.stringByTrimmingCharactersInSet(whiteSpace)
        if medicationText == "" {
            newAlert("No Name Entered", "Please type a medication name.")
            return
        }
        
        if countElements(medicationText) > 128 {
            newAlert("Name Too Long", "Please type a medication name that is shorter than 128 characters.")
            return
        }
        
        // Only allow numbers and letters for medication name
        if !checkValidCharacters(medicationText) {
            newAlert("Invalid Characters", "Please only use letters, numbers, and spaces when entering a medication.")
            return
        }
            
        let newMed = Medication(name: medicationText)
        if let insertMed = MedicationDAO.insertMedication(newMed) {
            
            if insertMed {
                performSegueWithIdentifier("addButtonPressed", sender: sender)
            }
            else {
                newAlert("Medication Already Exists", "A medication with name " + newMed.name + " has already been added, please choose another name.")
            }
            
        } else {
            newAlert("Unexpected Error", "An unexpected error has occurred, please try again.")
        }
    }
}
