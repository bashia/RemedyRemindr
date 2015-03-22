//
//  MedDetailsViewController.swift
//  RemedyRemindr
//
//  Created by Tony on 2015-02-10.
//  Copyright (c) 2015 Group 4. All rights reserved.
//

import UIKit

class MedDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var remindersTableView: UITableView!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    @IBOutlet weak var deleteBarButton: UIBarButtonItem!
    
    var inputMed : Medication?
    
    @IBAction func deleteButton(sender: UIButton) {
        
        var deleteConfirmationAlert = UIAlertController(title: "Delete Medication", message: "This medication and all associated reminders will be deleted.", preferredStyle: UIAlertControllerStyle.Alert)
        
        deleteConfirmationAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            if let deleteMedication = MedicationDAO.deleteMedication(self.inputMed!) {
                self.performSegueWithIdentifier("deleteMedication", sender: sender)
            } else {
                newAlert("Unexpected Error", "An unexpected error has occurred, please try again.")
            }
        }))
        
        deleteConfirmationAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))
        
        presentViewController(deleteConfirmationAlert, animated: true, completion: nil)
    }

    @IBAction func unwindToDetails(sender: UIStoryboardSegue) {
        // This happens after a new reminder is created
    }
    
    @IBAction func unwindToDetailsAfterDeleteReminder(sender: UIStoryboardSegue) {
        // This happens after a reminder is deleted
        self.remindersTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleText.text = inputMed!.name
        addBarButton.setTitleTextAttributes([NSFontAttributeName: smallLightFont!], forState: UIControlState.Normal)
        deleteBarButton.setTitleTextAttributes([NSFontAttributeName: smallLightFont!], forState: UIControlState.Normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.remindersTableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inputMed!.reminders.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ReminderCell", forIndexPath: indexPath) as UITableViewCell
        
        let reminder = inputMed?.reminders[indexPath.row]
        cell.textLabel?.text = reminder!.getTimesAsString()
        cell.detailTextLabel?.text = reminder!.getDaysAsString()
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addReminder"
        {
            var insertReminderView : ReminderTypeViewController = segue.destinationViewController as ReminderTypeViewController
            insertReminderView.inputMed = inputMed
        }
        
        if segue.identifier == "showReminderDetails"
        {
            var indexPath = self.remindersTableView.indexPathForSelectedRow()
            let rem = inputMed!.reminders[indexPath!.row]
            
            var detailsView : ReminderDetailsViewController = segue.destinationViewController as ReminderDetailsViewController
            detailsView.inputReminder = rem
            detailsView.inputMed = inputMed
        }
    }
    
}
