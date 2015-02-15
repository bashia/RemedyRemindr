//
//  ReminderDetailsViewController.swift
//  RemedyRemindr
//
//  Created by Tony on 2015-02-11.
//  Copyright (c) 2015 Group 4. All rights reserved.
//

import UIKit

class ReminderDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var reminderTitle: UILabel!
    @IBOutlet weak var textArea: UILabel!
    
    var inputReminder: Reminder?
    var inputMed: Medication?
    
    @IBAction func deleteReminder(sender: AnyObject) {
        
        var deleteConfirmationAlert = UIAlertController(title: "Delete Reminder", message: "This reminder will be deleted.", preferredStyle: UIAlertControllerStyle.Alert)
        
        deleteConfirmationAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            if let deleteReminder = MedicationDAO.deleteReminder(self.inputReminder!, medication: self.inputMed!) {
                self.performSegueWithIdentifier("deleteButtonPressed", sender: sender)
            } else {
                var alert : UIAlertView = UIAlertView(title: "Unexpected Error", message: "An unexpected error has occurred, please try again.", delegate: nil, cancelButtonTitle: "OK")
                alert.show()
            }
        }))
        
        deleteConfirmationAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))
        
        presentViewController(deleteConfirmationAlert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reminderTitle.text = inputMed!.name
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if inputReminder?.getRepeat() == Repeat.NO {
            return 3
        } else if inputReminder?.getStartDateAsString() ==  inputReminder?.getEndDateAsString() {
            return 4
        } else {
           return 5
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("InfoCell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
        
        // Show the start times no matter what
        if indexPath.row == 0 {
            cell.textLabel?.text = inputReminder!.getTimesAsString()
        }
            
        // Show the days string no matter what
        else if indexPath.row == 1 {
            cell.textLabel?.text = inputReminder!.getDaysAsString()
        }
        
        else {
            
            // If single day event, just show the notes
            if inputReminder?.getRepeat() == Repeat.NO {
                cell.textLabel?.text = inputReminder!.getNotes()
            }
            
            // If repeating forever
            else if inputReminder?.getStartDateAsString() ==  inputReminder?.getEndDateAsString() {
                
                // Show start date
                if indexPath.row == 2 {
                    cell.textLabel?.text = "Starting on " + inputReminder!.getStartDateAsString(NSDateFormatterStyle.LongStyle)
                }
                
                // Show notes
                else if indexPath.row == 3 {
                    cell.textLabel?.text = inputReminder!.getNotes()
                }
            }
            
            // If repeating until end date
            else {
                
                // Show start date
                if indexPath.row == 2 {
                    cell.textLabel?.text = "Starting on " + inputReminder!.getStartDateAsString(NSDateFormatterStyle.LongStyle)
                }
                
                // Show end date
                else if indexPath.row == 3 {
                    cell.textLabel?.text = "Ending on " + inputReminder!.getEndDateAsString(NSDateFormatterStyle.LongStyle)
                }
                
                // Show notes
                else if indexPath.row == 4 {
                    cell.textLabel?.text = inputReminder!.getNotes()
                }
            }
        }
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "deleteButtonPressed"
        {
            var medDetailsView : MedDetailsViewController = segue.destinationViewController as MedDetailsViewController
            for i in 0..<medDetailsView.inputMed!.reminders.count {
                if inputReminder!.isEqual(medDetailsView.inputMed!.reminders[i]) {
                    medDetailsView.inputMed!.reminders.removeAtIndex(i)
                }
            }
        }
    }
    

}
