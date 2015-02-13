//
//  TimePickerViewController.swift
//  RemedyRemindr
//
//  Created by Tony on 2015-02-13.
//  Copyright (c) 2015 Group 4. All rights reserved.
//

import UIKit

class TimePickerViewController: UIViewController {

    @IBOutlet weak var timePicker: UIDatePicker!
    
    @IBAction func cancelButton(sender: AnyObject) {
        performSegueWithIdentifier("timePopoverCancel", sender: sender)
        
    }
    
    @IBAction func doneButton(sender: AnyObject) {
        performSegueWithIdentifier("timePopoverDone", sender: sender)
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
        if segue.identifier == "timePopoverDone"
        {
            var destinationView : ReminderTimesViewController = segue.destinationViewController as ReminderTimesViewController
            let cal = NSCalendar.currentCalendar()
            let comp = cal.components((.HourCalendarUnit | .MinuteCalendarUnit), fromDate: timePicker.date)
            var minutesFromMidnight = Int16(comp.hour * 60 + comp.minute)
            destinationView.times.append(minutesFromMidnight)
        }
    }

}
