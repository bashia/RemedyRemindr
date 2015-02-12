//
//  ReminderRepeatViewController.swift
//  RemedyRemindr
//
//  Created by Tony on 2015-02-11.
//  Copyright (c) 2015 Group 4. All rights reserved.
//

import UIKit

class ReminderRepeatViewController: UIViewController {

    var reminder: Reminder?
    var inputMed : Medication?
    
    @IBAction func foreverButtonPressed(sender: AnyObject) {
        reminder!.setEndDate(reminder!.getStartDate())
        performSegueWithIdentifier("reminderRepeatForever", sender: sender)
    }
    
    @IBAction func customButtonPressed(sender: AnyObject) {
        performSegueWithIdentifier("reminderCustomEnd", sender: sender)
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
        if segue.identifier == "reminderRepeatForever"
        {
            var insertReminderView : ReminderDaysViewController = segue.destinationViewController as ReminderDaysViewController
            insertReminderView.inputMed = inputMed
            insertReminderView.reminder = reminder
        }
        if segue.identifier == "reminderCustomEnd"
        {
            var insertReminderView : ReminderEndViewController = segue.destinationViewController as ReminderEndViewController
            insertReminderView.inputMed = inputMed
            insertReminderView.reminder = reminder
        }
    }

}
