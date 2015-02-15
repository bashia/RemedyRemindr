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
    var times = [Int16]()
    
    @IBOutlet weak var timesTable: UITableView!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var doneButtonOutlet: UIButton!
    
    @IBAction func doneButton(sender: AnyObject) {
        performSegueWithIdentifier("reminderTimeSet", sender: sender)
    }
    
    @IBAction func deleteButton(sender: UIButton) {
        let rowToSelect:NSIndexPath  = NSIndexPath(forRow: sender.tag, inSection: 0)
        //timesTable.selectRowAtIndexPath(rowToSelect, animated: false, scrollPosition: UITableViewScrollPosition.None)
        times.removeAtIndex(sender.tag)
        timesTable.deleteRowsAtIndexPaths([rowToSelect], withRowAnimation: UITableViewRowAnimation.Fade)
        timesTable.reloadData()
        updateDoneButtonState()
    }

    @IBAction func timePopoverCancel(sender: UIStoryboardSegue) {
        dismissViewControllerAnimated(true, nil)
        updateDoneButtonState()
    }
    
    @IBAction func timePopoverDone(sender: UIStoryboardSegue) {
        dismissViewControllerAnimated(true, nil)
        timesTable.reloadData()
        updateDoneButtonState()
    }

    func updateDoneButtonState() {
        if (times.count > 0) {
            doneButtonOutlet.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            doneButtonOutlet.enabled = true
        } else {
            doneButtonOutlet.enabled = false
            doneButtonOutlet.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // If we have been passed a partially-completed reminder, load the previously-set time values
        if (reminder!.getTimes().count > 0) {
            times = reminder!.getTimes()
        }
        updateDoneButtonState()
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
        
        cell.textLabel?.text = Reminder.timeToString(times[indexPath.row])
        var deleteButton = UIButton()
        
        deleteButton.tag = indexPath.row
        deleteButton.frame = CGRectMake(200, 10, 75, 30)
        deleteButton.setTitle("Delete", forState: UIControlState.Normal)
        deleteButton.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        
        cell.addSubview(deleteButton)
        deleteButton.setTitleColor(darkBlueThemeColor, forState: UIControlState.Normal)
        deleteButton.addTarget(self, action: "deleteButton:", forControlEvents: UIControlEvents.TouchUpInside)
        
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "reminderTimeSet"
        {
            var insertReminderView : ReminderNotesViewController = segue.destinationViewController as ReminderNotesViewController
            
            reminder!.setTimes(times)
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
