//
//  CustomDaysViewController.swift
//  RemedyRemindr
//
//  Created by Tony on 2015-02-12.
//  Copyright (c) 2015 Group 4. All rights reserved.
//

import UIKit

class CustomDaysViewController: UIViewController {
    
    @IBAction func cancelButton(sender: AnyObject) {
        performSegueWithIdentifier("cancelPopover", sender: sender)
    }
    
    @IBAction func doneButton(sender: AnyObject) {
        performSegueWithIdentifier("donePopover", sender: sender)
    }
    
    @IBOutlet weak var numberOfDaysPicker: UIPickerView!
    var pickerData = [Int](2...100)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        if segue.identifier == "donePopover"
        {
            var daysView : ReminderDaysViewController = segue.destinationViewController as ReminderDaysViewController
            print(Int16(Int((pickerData[self.numberOfDaysPicker.selectedRowInComponent(0)]))))
            daysView.reminder!.setDays(Int16(Int((pickerData[self.numberOfDaysPicker.selectedRowInComponent(0)]))))
            print(daysView.reminder!.getDays())
        }
    }

}
