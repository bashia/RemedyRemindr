//
//  LogViewController.swift
//  RemedyRemindr
//
//  Created by RemedyRemindr Team on 2015-03-10.
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
    
    func getImageForCell(entry: LogEntry) -> UIImage? {
        
        if entry.getFeeling() < 0.20 {
            return UIImage(named: "sad-red")
        }
        
        if entry.getFeeling() < 0.40{
            return UIImage(named: "sad-yellow")
        }
        
        if entry.getFeeling() < 0.60{
            return UIImage(named: "ok-yellow")
        }
        
        
        if entry.getFeeling() < 0.80{
            return UIImage(named: "happy-yellow")
        }
        
        return UIImage(named: "happy-green")
        

    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("LogCell", forIndexPath: indexPath) as UITableViewCell
        
        let entry = entries[indexPath.row]
        
        if let mainLabel = cell.viewWithTag(3) as? UILabel {
            mainLabel.text = entry.getText()
        }
        if let subLabel = cell.viewWithTag(4) as? UILabel {
            subLabel.text = entry.getDateAsString()
        }

        if let imView = cell.viewWithTag(5) as? UIImageView{
            imView.image = getImageForCell(entry)
        }
        
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
