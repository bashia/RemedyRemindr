//
//  ReminderNotesViewController.swift
//  RemedyRemindr
//
//  Created by RemedyRemindr Team on 2015-02-11.
//  Copyright (c) 2015 Group 4. All rights reserved.
//

import UIKit

class ReminderNotesViewController: UIViewController, UITextViewDelegate {

    var reminder: Reminder?
    var inputMed : Medication?
    
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var notesTextView: UITextView!
    
    @IBAction func doneButton(sender: AnyObject) {
        
        if notesTextView.textColor == UIColor.lightGrayColor() {
            notesTextView.text = ""
        }
        
        reminder!.setNotes(notesTextView.text)
        
        if let insertRem = MedicationDAO.insertReminder(inputMed!, reminder: reminder!) {
            if insertRem {
                performSegueWithIdentifier("insertReminder", sender: sender)
            }
            else {
                var alert : UIAlertView = UIAlertView(title: "Duplicate Reminder", message: "A reminder already exists with the same date and time settings. Please go back and change some settings.", delegate: nil, cancelButtonTitle: "OK")
                alert.show()
            }
        } else {
            var alert : UIAlertView = UIAlertView(title: "Unexpected Error", message: "An unexpected error has occurred, please try again.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cancelBarButton.setTitleTextAttributes([NSFontAttributeName: mediumLightFont!], forState: UIControlState.Normal)
        
        notesTextView.text = "Enter any notes here"
        notesTextView.textColor = UIColor.lightGrayColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if notesTextView.textColor == UIColor.lightGrayColor() {
            notesTextView.text = nil
            notesTextView.textColor = UIColor.blackColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if notesTextView.text.isEmpty {
            notesTextView.text = "Enter any notes here"
            notesTextView.textColor = UIColor.lightGrayColor()
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
}
