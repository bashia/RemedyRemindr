//
//  MedListViewController.swift
//  RemedyRemindr
//
//  Created by Tony on 2015-02-11.
//  Copyright (c) 2015 Group 4. All rights reserved.
//

import UIKit

class MedListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var logButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var medsTableView: UITableView!
    
    var meds = [Medication]()

    @IBAction func unwindToMain(sender: UIStoryboardSegue) {
        // This comes from the detail view when you press the delete button
        self.medsTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addButton.setTitleTextAttributes([NSFontAttributeName: mediumLightFont!], forState: UIControlState.Normal)
        logButton.setTitleTextAttributes([NSFontAttributeName: mediumLightFont!], forState: UIControlState.Normal)        
        
        // Does nothing
       // NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleeditMed", name: "editMedNotification", object: nil
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let meds = MedicationDAO.getMedications() {
            self.meds = meds
            self.medsTableView.reloadData()
            
            /*let notman = NotificationManager()
            notman.makeNotification(meds[0])*/
            
            
        } else {
            var alert : UIAlertView = UIAlertView(title: "Unexpected Error", message: "An unexpected error has occurred while loading the medication list.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return meds.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MedicationCell", forIndexPath: indexPath) as UITableViewCell
        
        // Configure the cell...
        let med = meds[indexPath.row]
        cell.textLabel?.text = med.name
        
        var reminders = String(med.reminders.count) + " active reminder"
        if(med.reminders.count != 1)
        {
            reminders = reminders + "s"
        }
        
        cell.detailTextLabel?.text = reminders
    
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showMedicationDetails"
        {
            var detailsView : MedDetailsViewController = segue.destinationViewController as MedDetailsViewController
            
            var indexPath = self.medsTableView.indexPathForSelectedRow()
            let med = meds[indexPath!.row]
            
            detailsView.inputMed = med
        }
        
    }

}
