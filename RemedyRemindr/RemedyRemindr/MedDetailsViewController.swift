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
    @IBOutlet weak var TitleBar: UINavigationItem!
    
    var inputMed : Medication?
    
    @IBAction func deleteButton(sender: UIButton) {
        MedicationDAO.deleteMedication(inputMed!)
        performSegueWithIdentifier("deleteMedication", sender: sender)
    }

    @IBAction func unwindToDetails(sender: UIStoryboardSegue) {
        // This happens after a new reminder is created
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TitleBar.title = inputMed?.name
        
        // self.tableView?.registerClass(UITableViewCell.self, forCellReuseIdentifier: "ReminderCell")
        // self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("hello")
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
        cell.textLabel?.text = "Reminder " + String(indexPath.row)
        //cell.detailTextLabel?.text = String(reminder!.time)
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
            var insertReminderView : AddReminderViewController = segue.destinationViewController as AddReminderViewController
            insertReminderView.inputMed = inputMed
        }
        
        if segue.identifier == "showReminderDetails"
        {
            /* var detailsView : MedDetailsViewController = segue.destinationViewController as MedDetailsViewController
            
            var indexPath = self.remindersTableView.indexPathForSelectedRow()
            //let med = meds[indexPath!.row]
            
            //detailsView.inputMed = med*/
        }
    }
    
}
