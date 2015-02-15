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
        
        if let deleteMedication = MedicationDAO.deleteMedication(inputMed!) {
            performSegueWithIdentifier("deleteMedication", sender: sender)
        } else {
            var alert : UIAlertView = UIAlertView(title: "Unexpected Error", message: "An unexpected error has occurred, please try again.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
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
        
        // Configure the cell...
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
            let rem = inputMed?.reminders[indexPath!.row]
            
            var detailsView : ReminderDetailsViewController = segue.destinationViewController as ReminderDetailsViewController
            detailsView.inputReminder = rem
            detailsView.inputMed = inputMed
        }
    }
    
}
