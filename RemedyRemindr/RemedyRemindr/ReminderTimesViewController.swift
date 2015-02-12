//
//  ReminderTimesViewController.swift
//  RemedyRemindr
//
//  Created by Tony on 2015-02-11.
//  Copyright (c) 2015 Group 4. All rights reserved.
//

import UIKit

class ReminderTimesViewController: UIViewController {

    var reminder: Reminder?
    var inputMed : Medication?
    
    @IBOutlet weak var timePicker: UIDatePicker!
    
    @IBAction func doneButton(sender: AnyObject) {
        // Get the time
        let cal = NSCalendar.currentCalendar()
        let comp = cal.components((.HourCalendarUnit | .MinuteCalendarUnit), fromDate: timePicker.date)
        var minutesFromMidnight = Int16(comp.hour * 60 + comp.minute)
        
        reminder!.setTimes([minutesFromMidnight])
        performSegueWithIdentifier("reminderTimeSet", sender: sender)
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
        if segue.identifier == "reminderTimeSet"
        {
            var insertReminderView : ReminderNotesViewController = segue.destinationViewController as ReminderNotesViewController
            insertReminderView.inputMed = inputMed
            insertReminderView.reminder = reminder
        }
    }

}
