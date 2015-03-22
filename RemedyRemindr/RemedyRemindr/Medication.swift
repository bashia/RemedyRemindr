//
//  Medication.swift
//  RemedyRemindr
//
//  Created by Tony on 2015-02-08.
//  Copyright (c) 2015 Group 4. All rights reserved.
//

import Foundation

class Medication: NSObject {
    var name: String
    var reminders: [Reminder]
    
    init(name: String) {
        self.name = name
        reminders = []
    }
    
    /*func getnextReminderDates()->[NSDate] {
        
        /*
         Tony delete
        
        */
      /*  var remlist = reminders.filter({(x:Reminder) -> Bool in return x.getnextInstance() != nil}) //afternow's reminders all have next instances
        var datelist = [NSDate]()
        for rem in remlist {
            datelist.append(rem.popnextInstance()!)
        }*/
        return nil
    }*/
}