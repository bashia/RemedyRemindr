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
 
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    
    @IBAction func doneButton(sender: AnyObject) {
        reminder!.setEndDate(endDatePicker.date)
        if reminder!.getStartDateAsString() == reminder!.getEndDateAsString() {
            newAlert("Invalid Date", "You have chosen the end date to be the same as the start date. Please make a \"One Time\" reminder for this purpose.")
        } else {
            performSegueWithIdentifier("reminderCustomEndSet", sender: sender)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        endDatePicker.minimumDate = reminder!.getStartDate()
        cancelBarButton.setTitleTextAttributes([NSFontAttributeName: mediumLightFont!], forState: UIControlState.Normal)
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
