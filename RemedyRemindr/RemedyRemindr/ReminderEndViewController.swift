//
//  ReminderEndViewController.swift
//  RemedyRemindr
//
//  Created by Tony on 2015-02-11.
//  Copyright (c) 2015 Group 4. All rights reserved.
//

import UIKit

class ReminderEndViewController: UIViewController {

    var reminder: Reminder?
    var inputMed : Medication?
    
    
    @IBOutlet weak var endDatePicker: UIDatePicker!
    
    @IBAction func doneButton(sender: AnyObject) {
        // get the date
        reminder!.setEndDate(endDatePicker.date)
        performSegueWithIdentifier("reminderCustomEndSet", sender: sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "reminderCustomEndSet"
        {
            var insertReminderView : ReminderDaysViewController = segue.destinationViewController as ReminderDaysViewController
            insertReminderView.inputMed = inputMed
            insertReminderView.reminder = reminder
        }
    }

}
