//
//  ReminderTypeViewController.swift
//  RemedyRemindr
//
//  Created by RemedyRemindr Team on 2015-02-11.
//  Copyright (c) 2015 Group 4. All rights reserved.
//

import UIKit

class ReminderTypeViewController: UIViewController {

    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    
    var reminder: Reminder?
    var inputMed : Medication?
    
    @IBAction func oneTimePressed(sender: AnyObject) {
        reminder = Reminder()
        reminder!.setRepeat(Repeat.NO)
        performSegueWithIdentifier("reminderTypeSet", sender: sender)
    }
    
    @IBAction func repeatingPressed(sender: AnyObject) {
        reminder = Reminder()
        reminder!.setRepeat(Repeat.YES_CUSTOM)
        reminder!.setDays(1)
        performSegueWithIdentifier("reminderTypeSet", sender: sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cancelBarButton.setTitleTextAttributes([NSFontAttributeName: mediumLightFont!], forState: UIControlState.Normal)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "reminderTypeSet"
        {
            var insertReminderView : ReminderStartViewController = segue.destinationViewController as ReminderStartViewController
            insertReminderView.inputMed = inputMed
            insertReminderView.reminder = reminder
        }
    }

}
