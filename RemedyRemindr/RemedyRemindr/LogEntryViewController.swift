//
//  LogEntryViewController.swift
//  RemedyRemindr
//
//  Created by Tony on 2015-03-10.
//  Copyright (c) 2015 Group 4. All rights reserved.
//

import UIKit

class LogEntryViewController: UIViewController {

    
    @IBOutlet weak var feelingSlider: UISlider!
    @IBOutlet weak var textArea: UITextView!
    
    
    @IBAction func entryPopoverDone(sender: AnyObject) {
        performSegueWithIdentifier("EntryPopoverDone", sender: sender)
    }

    @IBAction func entryPopoverCancel(sender: AnyObject) {
        performSegueWithIdentifier("EntryPopoverCancel", sender: sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textArea.layer.borderWidth = 1.0
    
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EntryPopoverDone"
        {
            
            let newEntry = LogEntry(date: NSDate(), text: textArea.text, feeling: feelingSlider.value)

            if let insertedEntry = MedicationDAO.insertLogEntry(newEntry) {
                
                var destinationView : LogViewController = segue.destinationViewController as LogViewController
                destinationView.reloadData()
                
            }
            else {
                newAlert("Unexpected Error", "An unexpected error has occurred, please try again.")
            }
        }
 
    }
}
