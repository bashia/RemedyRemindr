//
//  AddReminderViewController.swift
//  RemedyRemindr
//
//  Created by Tony on 2015-02-11.
//  Copyright (c) 2015 Group 4. All rights reserved.
//

import UIKit

class AddReminderViewController: UIViewController {

    var inputMed : Medication?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func doneButtonPressed(sender: AnyObject) {
        
        let cal = NSCalendar.currentCalendar()
        let comp = cal.components((.HourCalendarUnit | .MinuteCalendarUnit), fromDate: datePicker.date)
        var minutesFromMidnight = Int16(comp.hour * 60 + comp.minute)
        
        var rem = Reminder()
        rem.setTimes([minutesFromMidnight])
        
        MedicationDAO.insertReminder(inputMed!, reminder: rem)
        performSegueWithIdentifier("insertReminder", sender: sender)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
