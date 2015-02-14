//
//  ReminderNotesViewController.swift
//  RemedyRemindr
//
//  Created by Tony on 2015-02-11.
//  Copyright (c) 2015 Group 4. All rights reserved.
//

import UIKit

class ReminderNotesViewController: UIViewController {

    var reminder: Reminder?
    var inputMed : Medication?
    
    @IBOutlet weak var notesTextView: UITextView!
    @IBAction func doneButton(sender: AnyObject) {
        reminder!.setNotes(notesTextView.text)
        
        if(MedicationDAO.insertReminder(inputMed!, reminder: reminder!) == 1)
        {
            var alert : UIAlertView = UIAlertView(title: "Duplicate Reminder", message: "A reminder already exists with the same date and time settings. Please go back and change some settings.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
        else
        {
            performSegueWithIdentifier("insertReminder", sender: sender)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
