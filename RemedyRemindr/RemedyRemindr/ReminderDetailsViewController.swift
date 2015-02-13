//
//  ReminderDetailsViewController.swift
//  RemedyRemindr
//
//  Created by Tony on 2015-02-11.
//  Copyright (c) 2015 Group 4. All rights reserved.
//

import UIKit

class ReminderDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var reminderTitle: UILabel!
    
    
    @IBOutlet weak var textArea: UILabel!
    var inputReminder: Reminder?
    var inputName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reminderTitle.text = inputName
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if inputReminder?.getRepeat() == Repeat.NO {
            return 3
        } else if inputReminder?.getStartDateAsString() ==  inputReminder?.getEndDateAsString() {
            return 4
        } else {
           return 5
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("InfoCell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
        
        // Show the start times no matter what
        if indexPath.row == 0 {
            cell.textLabel?.text = inputReminder!.getTimesAsString()
        }
            
        // Show the days string no matter what
        else if indexPath.row == 1 {
            cell.textLabel?.text = inputReminder!.getDaysAsString()
        }
        
        else {
            
            // If single day event, just show the notes
            if inputReminder?.getRepeat() == Repeat.NO {
                cell.textLabel?.text = inputReminder!.getNotes()
            }
            
            // If repeating forever
            else if inputReminder?.getStartDateAsString() ==  inputReminder?.getEndDateAsString() {
                
                // Show start date
                if indexPath.row == 2 {
                    cell.textLabel?.text = "Starting on " + inputReminder!.getStartDateAsString(NSDateFormatterStyle.LongStyle)
                }
                
                // Show notes
                else if indexPath.row == 3 {
                    cell.textLabel?.text = inputReminder!.getNotes()
                }
            }
            
            // If repeating until end date
            else {
                
                // Show start date
                if indexPath.row == 2 {
                    cell.textLabel?.text = "Starting on " + inputReminder!.getStartDateAsString(NSDateFormatterStyle.LongStyle)
                }
                
                // Show end date
                else if indexPath.row == 3 {
                    cell.textLabel?.text = "Ending on " + inputReminder!.getEndDateAsString(NSDateFormatterStyle.LongStyle)
                }
                
                // Show notes
                else if indexPath.row == 4 {
                    cell.textLabel?.text = inputReminder!.getNotes()
                }
            }
        }
        
        
        
        
        /*
        var deleteButton = UIButton()
        
        deleteButton.tag = indexPath.row
        deleteButton.frame = CGRectMake(200, 5, 75, 30)
        deleteButton.setTitle("Delete", forState: UIControlState.Normal)
        
        
        cell.addSubview(deleteButton)
        deleteButton.setTitleColor(darkBlueThemeColor, forState: UIControlState.Normal)
        deleteButton.addTarget(self, action: "deleteButton:", forControlEvents: UIControlEvents.TouchUpInside)
        */
        
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

}
