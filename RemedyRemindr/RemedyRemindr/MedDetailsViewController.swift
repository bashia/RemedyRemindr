//
//  MedDetailsViewController.swift
//  RemedyRemindr
//
//  Created by Tony on 2015-02-10.
//  Copyright (c) 2015 Group 4. All rights reserved.
//

import UIKit

class MedDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var TitleBar: UINavigationItem!
    
    // Need to rename this
    var data : Medication?
    
    @IBAction func deleteButton(sender: UIButton) {
        MedicationDAO.deleteData(data!)
        performSegueWithIdentifier("deleteMedication", sender: sender)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        TitleBar.title = data?.name
        print(data!.reminders.count)
        
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
    }
    
    // MARK: - Table view data source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data!.reminders.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ReminderCell", forIndexPath: indexPath) as UITableViewCell
        
        // Configure the cell...
        let reminder = data?.reminders[indexPath.row]
        cell.textLabel?.text = "Reminder " + String(indexPath.row)
        cell.detailTextLabel?.text = String(reminder!.time)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
}
