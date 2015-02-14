//
//  MedListViewController.swift
//  RemedyRemindr
//
//  Created by Tony on 2015-02-11.
//  Copyright (c) 2015 Group 4. All rights reserved.
//

import UIKit

class MedListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var addButton: UIBarButtonItem!
    
    var meds = [Medication]()
    @IBOutlet weak var medsTableView: UITableView!
    
    @IBAction func unwindToMain(sender: UIStoryboardSegue) {
        // This comes from the detail view when you press the delete button
        self.medsTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addButton.setTitleTextAttributes([NSFontAttributeName: mediumLightFont!], forState: UIControlState.Normal)
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        meds = MedicationDAO.getMedications()!
        self.medsTableView.reloadData()
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
        cell.detailTextLabel?.text = String(med.reminders.count) + " active reminders"
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
