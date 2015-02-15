//
//  ReminderDaysViewController.swift
//  RemedyRemindr
//
//  Created by Tony on 2015-02-11.
//  Copyright (c) 2015 Group 4. All rights reserved.
//

import UIKit

class ReminderDaysViewController: UIViewController {

    @IBOutlet weak var confirmLabel: UILabel!
    
    var reminder: Reminder?
    var inputMed : Medication?
    
    @IBAction func everyDayButton(sender: AnyObject) {
        // Do something
        performSegueWithIdentifier("reminderDaysSet", sender: sender)
    }
    
    @IBAction func weeklyButton(sender: AnyObject) {
        reminder!.setRepeat(Repeat.YES_WEEKLY)
        performSegueWithIdentifier("customWeekly", sender: sender)
    }
    
    @IBAction func customDaysButton(sender: AnyObject) {
        performSegueWithIdentifier("customDays", sender: sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
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
        else if segue.identifier == "customDays" {
            var insertReminderView : CustomDaysViewController = segue.destinationViewController as CustomDaysViewController
            insertReminderView.inputMed = inputMed
            insertReminderView.reminder = reminder
        }
        else if segue.identifier == "customWeekly" {
            var insertReminderView : CustomWeeklyViewController = segue.destinationViewController as CustomWeeklyViewController
            insertReminderView.inputMed = inputMed
            insertReminderView.reminder = reminder
        }
    }

}
