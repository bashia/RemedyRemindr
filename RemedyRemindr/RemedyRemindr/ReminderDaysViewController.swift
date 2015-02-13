//
//  ReminderDaysViewController.swift
//  RemedyRemindr
//
//  Created by Tony on 2015-02-11.
//  Copyright (c) 2015 Group 4. All rights reserved.
//

import UIKit

class ReminderDaysViewController: UIViewController, UIPopoverPresentationControllerDelegate {

    var reminder: Reminder?
    var inputMed : Medication?
    
    @IBAction func everyDayButton(sender: AnyObject) {
        // Do something
        print(sender)
        performSegueWithIdentifier("reminderDaysSet", sender: sender)
    }
    
    @IBAction func dismissPopover(sender: UIStoryboardSegue) {
        // This happens after the popover cancel button is pressed
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func donePopover(sender: UIStoryboardSegue) {
        // This happens after the popover cancel button is pressed
        self.dismissViewControllerAnimated(true, completion: nil)
        performSegueWithIdentifier("reminderDaysSet", sender: nil)
    }
    
    @IBAction func weeklyButton(sender: AnyObject) {
        reminder!.setRepeat(Repeat.YES_WEEKLY)
        performSegueWithIdentifier("customWeeklyPopover", sender: sender)
    }
    
    @IBAction func customDaysButton(sender: AnyObject) {
        performSegueWithIdentifier("customDaysPopover", sender: sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "reminderDaysSet"
        {
            var insertReminderView : ReminderTimesViewController = segue.destinationViewController as ReminderTimesViewController
            insertReminderView.inputMed = inputMed
            insertReminderView.reminder = reminder
        }
        else if segue.identifier == "customDaysPopover" {
            let popoverViewController = segue.destinationViewController as UIViewController
            popoverViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
            popoverViewController.popoverPresentationController!.delegate = self
        }
        else if segue.identifier == "customWeeklyPopover" {
            let popoverViewController = segue.destinationViewController as UIViewController
            popoverViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
            popoverViewController.popoverPresentationController!.delegate = self
        }
    }

}
