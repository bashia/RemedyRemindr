//
//  ReminderDaysViewController.swift
//  RemedyRemindr
//
//  Created by Tony on 2015-02-11.
//  Copyright (c) 2015 Group 4. All rights reserved.
//

import UIKit

class ReminderDaysViewController: UIViewController {

    var reminder: Reminder?
    var inputMed : Medication?
    
    @IBAction func everyDayButton(sender: AnyObject) {
        performSegueWithIdentifier("reminderDaysSet", sender: sender)
    }
    
    @IBAction func weeklyButton(sender: AnyObject) {
        // Alert to do
        performSegueWithIdentifier("reminderDaysSet", sender: sender)
    }
    
    @IBAction func customDaysButton(sender: AnyObject) {
        // Alert to do
        performSegueWithIdentifier("reminderDaysSet", sender: sender)
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
        if segue.identifier == "reminderDaysSet"
        {
            var insertReminderView : ReminderTimesViewController = segue.destinationViewController as ReminderTimesViewController
            insertReminderView.inputMed = inputMed
            insertReminderView.reminder = reminder
        }
    }

}
