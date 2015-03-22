//
//  NotificationManagement.swift
//  RemedyRemindr
//
//  Created by Anthony Bashi on 2015-02-09.
//  Copyright (c) 2015 Group 4. All rights reserved.
//

import Foundation
import UIKit


class NotificationManager{
    
    let snoozedefault = 1
    
    
    /*
    * Sets the fire date's second as zero so the notification will appear at the start of the minute
    */
    func fixNotificationDate(dateToFix: NSDate) -> NSDate {
        var dateComponets: NSDateComponents = NSCalendar.currentCalendar().components(NSCalendarUnit.DayCalendarUnit | NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.YearCalendarUnit | NSCalendarUnit.HourCalendarUnit | NSCalendarUnit.MinuteCalendarUnit, fromDate: dateToFix)
        
        dateComponets.second = 0
        
        var fixedDate: NSDate! = NSCalendar.currentCalendar().dateFromComponents(dateComponets)
        
        return fixedDate
    }
    
    
    
    
    
    func makeNotification(med:Medication) {
        
        var localNotification = UILocalNotification()
        
        //localNotification.fireDate = NSDate(timeInterval: 3, sinceDate: date)
        
        
        /*localNotification.fireDate = NSDate(timeInterval: 40, sinceDate: NSDate())
        //localNotification.fireDate = fixNotificationDate(date)
        localNotification.alertBody = "Medication Alert: " + med.name + "!"
        localNotification.alertAction = "View"
        localNotification.category = "RemCat"
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)*/
        
        var remdatelist = med.getnextReminderDates()
        
        for date in remdatelist{
        
            var localNotification = UILocalNotification()
            
            //localNotification.fireDate = NSDate(timeInterval: 3, sinceDate: date)
            
            
            localNotification.fireDate = NSDate(timeInterval: 3, sinceDate: fixNotificationDate(date))
            //localNotification.fireDate = fixNotificationDate(date)
            localNotification.alertBody = "Medication Alert: " + med.name + "!"
            localNotification.alertAction = "View"
            localNotification.category = "RemCat"
            
            UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        }
    }
    
    func rescheduleNotification(note:UILocalNotification, minsoffset: Int){
        var newnot = note
        var secsoffset = 60*minsoffset
        newnot.fireDate = NSDate(timeInterval: NSTimeInterval(secsoffset), sinceDate: note.fireDate!)
        
        UIApplication.sharedApplication().scheduleLocalNotification(newnot)
        println("Notification resheduled for" + newnot.fireDate!.description)
    }
    
    func updateNotifications(){
    
        if UIApplication.sharedApplication().scheduledLocalNotifications.count > 16{
            return
        }
        
        let medications:[Medication] = MedicationDAO.getMedications()!
        
        for med in medications{
            makeNotification(med)
        }
    }
    
    init(){
        
        // Only need to execute once per app run. Make this a singleton.
        
        var notificationTypes: UIUserNotificationType = UIUserNotificationType.Alert | UIUserNotificationType.Sound
        
        
        // Confirm action
        var confirmDose = UIMutableUserNotificationAction()
        confirmDose.identifier = "confirmDose"
        confirmDose.title = "Confirm Dose"
        confirmDose.activationMode = UIUserNotificationActivationMode.Background
        confirmDose.destructive = false
        confirmDose.authenticationRequired = false
        
        // Snooze action
        var snooze = UIMutableUserNotificationAction()
        snooze.identifier = "snooze"
        snooze.title = "Snooze"
        snooze.activationMode = UIUserNotificationActivationMode.Background
        snooze.destructive = false
        snooze.authenticationRequired = false
        
        // Skip action
        var skip = UIMutableUserNotificationAction()
        skip.identifier = "skipDose"
        skip.title = "Skip Dose"
        skip.activationMode = UIUserNotificationActivationMode.Background
        skip.destructive = false
        skip.authenticationRequired = false
        
        
        let actionsArray = NSArray(objects: confirmDose, snooze)
        let actionsArrayMinimal = NSArray(objects: confirmDose, snooze)
            
        // Specify the category related to the above actions.
        var RemedyRemindrCategory = UIMutableUserNotificationCategory()
        RemedyRemindrCategory.identifier = "RemCat"
        RemedyRemindrCategory.setActions(actionsArray, forContext: UIUserNotificationActionContext.Default)
        RemedyRemindrCategory.setActions(actionsArrayMinimal, forContext: UIUserNotificationActionContext.Minimal)
        
        
        /*var TestCat = UIMutableUserNotificationCategory()
        TestCat.identifier = "TestCat"*/
        
        let categoriesForSettings = NSSet(objects: RemedyRemindrCategory)
            
        // Register the notification settings.
        let newNotificationSettings = UIUserNotificationSettings(forTypes: notificationTypes, categories: categoriesForSettings)
        UIApplication.sharedApplication().registerUserNotificationSettings(newNotificationSettings)
        
        //println("NotificationManager initialized!")

    }
}


