//
//  ReminderTimesViewController.swift
//  RemedyRemindr
//
//  Created by Tony on 2015-02-11.
//  Copyright (c) 2015 Group 4. All rights reserved.
//

import UIKit

class ReminderTimesViewController: UIViewController, UIPopoverPresentationControllerDelegate, UITableViewDelegate, UITableViewDataSource {

    var reminder: Reminder?
    var inputMed : Medication?
    
    var times = [123, 234, 345]
    
    @IBOutlet weak var timesTable: UITableView!
    @IBOutlet weak var timePicker: UIDatePicker!
    
    @IBOutlet weak var doneButtonOutlet: UIButton!
    @IBAction func doneButton(sender: AnyObject) {
        // Get the time
        /*let cal = NSCalendar.currentCalendar()
        let comp = cal.components((.HourCalendarUnit | .MinuteCalendarUnit), fromDate: timePicker.date)
        var minutesFromMidnight = Int16(comp.hour * 60 + comp.minute)
        
        // Add time picker
        reminder!.setTimes([minutesFromMidnight])
        performSegueWithIdentifier("reminderTimeSet", sender: sender)*/
    }
    
    
    @IBAction func deleteButton(sender: UIButton) {
        let rowToSelect:NSIndexPath  = NSIndexPath(forRow: sender.tag, inSection: 0)
        //timesTable.selectRowAtIndexPath(rowToSelect, animated: false, scrollPosition: UITableViewScrollPosition.None)
        times.removeAtIndex(sender.tag)
        timesTable.deleteRowsAtIndexPaths([rowToSelect], withRowAnimation: UITableViewRowAnimation.Fade)
        timesTable.reloadData()
        print (sender.tag)
    }

    @IBAction func timePopoverCancel(sender: UIStoryboardSegue) {
        dismissViewControllerAnimated(true, nil)
    }
    
    @IBAction func timePopoverDone(sender: UIStoryboardSegue) {
        doneButtonOutlet.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        doneButtonOutlet.enabled = true
        dismissViewControllerAnimated(true, nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        doneButtonOutlet.enabled = false
        doneButtonOutlet.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return times.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TimeCell", forIndexPath: indexPath) as UITableViewCell
        
        let title = cell.viewWithTag(4) as UILabel
        var deleteButton = UIButton()
        
        deleteButton.tag = indexPath.row
        deleteButton.frame = CGRectMake(200, 5, 75, 30)
        deleteButton.setTitle("Delete", forState: UIControlState.Normal)
        
        cell.addSubview(deleteButton)
        deleteButton.setTitleColor(darkBlueThemeColor, forState: UIControlState.Normal)
        deleteButton.addTarget(self, action: "deleteButton:", forControlEvents: UIControlEvents.TouchUpInside)
        title.text = String(times[indexPath.row])
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "reminderTimeSet"
        {
            var insertReminderView : ReminderNotesViewController = segue.destinationViewController as ReminderNotesViewController
            insertReminderView.inputMed = inputMed
            insertReminderView.reminder = reminder
        }
        if segue.identifier == "timePopover" {
            let popoverViewController = segue.destinationViewController as UIViewController
            popoverViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
            popoverViewController.popoverPresentationController!.delegate = self
        }
    }

}
