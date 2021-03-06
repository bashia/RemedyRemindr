//
//  CustomDaysViewController.swift
//  RemedyRemindr
//
//  Created by RemedyRemindr Team on 2015-02-12.
//  Copyright (c) 2015 Group 4. All rights reserved.
//

import UIKit

class CustomDaysViewController: UIViewController {
    
    var reminder: Reminder?
    var inputMed : Medication?
    
    var pickerData = [Int](2...100)
    
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var numberOfDaysPicker: UIPickerView!
    
    @IBAction func doneButton(sender: AnyObject) {
        reminder?.setDays(Int16(pickerData[numberOfDaysPicker.selectedRowInComponent(0)]))
        performSegueWithIdentifier("reminderDaysSet", sender: sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cancelBarButton.setTitleTextAttributes([NSFontAttributeName: mediumLightFont!], forState: UIControlState.Normal)
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return String(pickerData[row])
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
