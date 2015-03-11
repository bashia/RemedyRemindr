//
//  LogViewController.swift
//  RemedyRemindr
//
//  Created by Tony on 2015-03-10.
//  Copyright (c) 2015 Group 4. All rights reserved.
//

import UIKit

class LogViewController: UIViewController, UIPopoverPresentationControllerDelegate, UITableViewDelegate, UITableViewDataSource {

    
    var entries = [LogEntry]()
    
    @IBOutlet weak var newButton: UIBarButtonItem!
    @IBOutlet weak var entriesViewTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        newButton.setTitleTextAttributes([NSFontAttributeName: mediumLightFont!], forState: UIControlState.Normal)
        // Do any additional setup after loading the view.
    }

    @IBAction func deleteLogEntry(sender: UIStoryboardSegue) {
        // This comes from the log entry view when you hit delete

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }
    
    func reloadData() {
        if let entries = MedicationDAO.getLogEntries() {
            self.entries = entries
            self.entriesViewTable.reloadData()
        } else {
            var alert : UIAlertView = UIAlertView(title: "Unexpected Error", message: "An unexpected error has occurred while loading the log entry list", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
    }
    
    @IBAction func entryPopoverCancel(sender: UIStoryboardSegue) {
        dismissViewControllerAnimated(true, nil)
    }
    
    @IBAction func entryPopoverDone(sender: UIStoryboardSegue) {
        dismissViewControllerAnimated(true, nil)
        entriesViewTable.reloadData()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("LogCell", forIndexPath: indexPath) as UITableViewCell
        
        let entry = entries[indexPath.row]
        cell.textLabel?.text = entry.getText()
        cell.detailTextLabel?.text = entry.getDateAsString()

        return cell
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EntryPopover" {
            let popoverViewController = segue.destinationViewController as UIViewController
                popoverViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
                popoverViewController.popoverPresentationController!.delegate = self
        }
        
        else if segue.identifier == "EntryDetailsPopover" {
            var destinationView : LogEntryDetailsViewController = segue.destinationViewController as LogEntryDetailsViewController
            
            var indexPath = self.entriesViewTable.indexPathForSelectedRow()
            let entry = entries[indexPath!.row]

            destinationView.entry = entry
            
        }
    }


}
