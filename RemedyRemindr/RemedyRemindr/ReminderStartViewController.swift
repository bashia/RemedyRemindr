//
//  ReminderStartViewController.swift
//  RemedyRemindr
//
//  Created by Tony on 2015-02-11.
//  Copyright (c) 2015 Group 4. All rights reserved.
//

import UIKit

class ReminderStartViewController: UIViewController {

    var reminder: Reminder?
    var inputMed : Medication?
    
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBAction func doneButtonPressed(sender: AnyObject) {
        reminder!.setStartDate(startDatePicker.date)
        
        if reminder?.getRepeat() == Repeat.NO {
            performSegueWithIdentifier("reminderStartSetNoRepeat", sender: sender)
        }
        else {
            performSegueWithIdentifier("reminderStartSetRepeat", sender: sender)
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "reminderStartSetNoRepeat"
        {
            var insertReminderView : ReminderTimesViewController = segue.destinationViewController as ReminderTimesViewController
            insertReminderView.inputMed = inputMed
            insertReminderView.reminder = reminder
        }
        else if segue.identifier == "reminderStartSetRepeat"
        {
            var insertReminderView : ReminderRepeatViewController = segue.destinationViewController as ReminderRepeatViewController
            insertReminderView.inputMed = inputMed
            insertReminderView.reminder = reminder
        }
    }

}
