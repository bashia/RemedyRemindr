//
//  CustomWeeklyViewController.swift
//  RemedyRemindr
//
//  Created by Tony on 2015-02-12.
//  Copyright (c) 2015 Group 4. All rights reserved.
//

import UIKit

class CustomWeeklyViewController: UIViewController {
    
    var reminder: Reminder?
    var inputMed : Medication?
    
    @IBOutlet weak var sundaySlider: UISwitch!
    @IBOutlet weak var mondaySlider: UISwitch!
    @IBOutlet weak var tuesdaySlider: UISwitch!
    @IBOutlet weak var wednesdaySlider: UISwitch!
    @IBOutlet weak var thursdaySlider: UISwitch!
    @IBOutlet weak var fridaySlider: UISwitch!
    @IBOutlet weak var saturdaySlider: UISwitch!

    @IBAction func sundayButton(sender: AnyObject) {
        sundaySlider.setOn(sundaySlider.on == false, animated: true)
    }
    @IBAction func mondayButton(sender: AnyObject) {
        mondaySlider.setOn(mondaySlider.on == false, animated: true)
    }
    @IBAction func tuesdayButton(sender: AnyObject) {
        tuesdaySlider.setOn(tuesdaySlider.on == false, animated: true)
    }
    @IBAction func wendesdayButton(sender: AnyObject) {
        wednesdaySlider.setOn(wednesdaySlider.on == false, animated: true)
    }
    @IBAction func thursdayButton(sender: AnyObject) {
        thursdaySlider.setOn(thursdaySlider.on == false, animated: true)
    }
    @IBAction func fridayButton(sender: AnyObject) {
        fridaySlider.setOn(fridaySlider.on == false, animated: true)
    }
    @IBAction func saturdayButton(sender: AnyObject) {
        saturdaySlider.setOn(saturdaySlider.on == false, animated: true)
    }
    
    @IBAction func doneButton(sender: AnyObject) {
        
        let sliders = [saturdaySlider, fridaySlider, thursdaySlider, wednesdaySlider, tuesdaySlider, mondaySlider, sundaySlider]
        var dayBits = Int16(0)
        
        for i in 0...6 {
            dayBits = dayBits << 1
            var day : Int16 = sliders[i].on ? 0x0001 : 0x0000
            dayBits = dayBits | day
        }
        
        if (dayBits == 0) {
            newAlert("No days selected", "Please select at least one day of the week for this reminder to occur on.")
        } else {
            reminder!.setDays(dayBits)
            performSegueWithIdentifier("reminderDaysSet", sender: sender)
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
        if segue.identifier == "reminderDaysSet"
        {
            var insertReminderView : ReminderTimesViewController = segue.destinationViewController as ReminderTimesViewController
            insertReminderView.inputMed = inputMed
            insertReminderView.reminder = reminder
        }
    }

}
