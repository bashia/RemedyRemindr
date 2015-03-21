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
    
    // Rotating the screen messes up the popover, so we dismiss it if the screen rotates
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation)  {
        performSegueWithIdentifier("timePopoverCancel", sender: nil)
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "timePopoverDone"
        {
            var destinationView : ReminderTimesViewController = segue.destinationViewController as ReminderTimesViewController
            let cal = NSCalendar.currentCalendar()
            let comp = cal.components((.HourCalendarUnit | .MinuteCalendarUnit), fromDate: timePicker.date)
            var minutesFromMidnight = Int16(comp.hour * 60 + comp.minute)
            
            if contains(destinationView.times, minutesFromMidnight) {
                newAlert("Duplicate Time", "This time has already been added for this reminder.")
            } else {
                destinationView.times.append(minutesFromMidnight)
            }
        }
    }

}
