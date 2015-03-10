//
//  LogEntryDetailsViewController.swift
//  RemedyRemindr
//
//  Created by Tony on 2015-03-10.
//  Copyright (c) 2015 Group 4. All rights reserved.
//

import UIKit

class LogEntryDetailsViewController: UIViewController {

    @IBOutlet weak var dateTextView: UITextView!
    @IBOutlet weak var entryTextView: UITextView!
    
    var entry : LogEntry?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateTextView.text = entry?.getDateAsString()
        entryTextView.text = entry?.getText()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func entryPopoverOK(sender: AnyObject) {
        performSegueWithIdentifier("EntryPopoverOK", sender: sender)
    }
}
