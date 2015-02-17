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
    
    func fixNotificationDate(dateToFix: NSDate) -> NSDate {
        var dateComponents: NSDateComponents = NSCalendar.currentCalendar().components(NSCalendarUnit.DayCalendarUnit | NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.YearCalendarUnit | NSCalendarUnit.HourCalendarUnit | NSCalendarUnit.MinuteCalendarUnit, fromDate: dateToFix)
        
        dateComponents.second = 0
        
        var fixedDate: NSDate! = NSCalendar.currentCalendar().dateFromComponents(dateComponents)
        
        return fixedDate
    }
    
    func makeNotificationforReminder(reminder: Reminder){
        
    }
    
    func makeNotificationsforMed(med: Medication){
        
        let date = NSDate(timeIntervalSinceNow: 60)
        
        for reminder in med.reminders{
            
            var localNotification = UILocalNotification()
            localNotification.fireDate = fixNotificationDate(date)
            localNotification.alertBody = "Medication Alert:" + med.name + "!"
            localNotification.alertAction = "View List"
            localNotification.category = "RemedyRemindrCategory"
            localNotification.userInfo = ["med":med]
            
            UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
            
            
        }
        
        
        
        
        
    }
    
    func checkNotifications(med: Medication){
        
        let app = UIApplication()
        let notifications = app.scheduledLocalNotifications
        
        
    }
    
    init(){
        let notificationSettings: UIUserNotificationSettings! = UIApplication.sharedApplication().currentUserNotificationSettings()
        
        if (notificationSettings.types == UIUserNotificationType.None){
            // Specify the notification types.
            var notificationTypes: UIUserNotificationType = UIUserNotificationType.Alert | UIUserNotificationType.Sound
            
            // Specify the notification actions.
            var confirmDose = UIMutableUserNotificationAction()
            confirmDose.identifier = "confirmDose"
            confirmDose.title = "Confirm"
            confirmDose.activationMode = UIUserNotificationActivationMode.Background
            confirmDose.destructive = false
            confirmDose.authenticationRequired = false
            
            var editMed = UIMutableUserNotificationAction()
            editMed.identifier = "editMed"
            editMed.title = "Go to App"
            editMed.activationMode = UIUserNotificationActivationMode.Foreground
            editMed.destructive = false
            editMed.authenticationRequired = true
            
            var snooze = UIMutableUserNotificationAction()
            snooze.identifier = "snooze"
            snooze.title = "Snooze"
            snooze.activationMode = UIUserNotificationActivationMode.Background
            snooze.destructive = false
            snooze.authenticationRequired = false
            
            let actionsArray = NSArray(objects: confirmDose,snooze,editMed)
            let actionsArrayMinimal = NSArray(objects: confirmDose,snooze)
            
            // Specify the category related to the above actions.
            var RemedyRemindrCategory = UIMutableUserNotificationCategory()
            RemedyRemindrCategory.identifier = "RemedyRemindrCategory"
            RemedyRemindrCategory.setActions(actionsArray, forContext: UIUserNotificationActionContext.Default)
            RemedyRemindrCategory.setActions(actionsArrayMinimal, forContext: UIUserNotificationActionContext.Minimal)
            
            let categoriesForSettings = NSSet(objects: RemedyRemindrCategory)
            
            // Register the notification settings.
            let newNotificationSettings = UIUserNotificationSettings(forTypes: notificationTypes, categories: categoriesForSettings)
            UIApplication.sharedApplication().registerUserNotificationSettings(newNotificationSettings)
            
            println("NotificationManager initialized!")
    }

    }
}
