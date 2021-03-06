//
//  LogEntryDetailsViewController.swift
//  RemedyRemindr
//
//  Created by RemedyRemindr Team on 2015-03-10.
//  Copyright (c) 2015 Group 4. All rights reserved.
//

import UIKit

class LogEntryDetailsViewController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var feelingSlider: UISlider!
    @IBOutlet weak var entryTextView: UITextView!

    var entry : LogEntry?
    
    @IBAction func deleteButtonPressed(sender: AnyObject) {
        
        
        var deleteConfirmationAlert = UIAlertController(title: "Delete Log Entry", message: "This log entry will be deleted.", preferredStyle: UIAlertControllerStyle.Alert)
        
        deleteConfirmationAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            if let deleteMedication = MedicationDAO.deleteLogEntry(self.entry!) {
                self.performSegueWithIdentifier("DeleteLogEntry", sender: sender)
            } else {
                newAlert("Unexpected Error", "An unexpected error has occurred, please try again.")
            }
        }))
        
        deleteConfirmationAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))
        
        presentViewController(deleteConfirmationAlert, animated: true, completion: nil)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateLabel.text = entry!.getDateAsString()
        entryTextView.text = entry!.getText()
        entryTextView.editable = false
        feelingSlider.value = entry!.getFeeling()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
