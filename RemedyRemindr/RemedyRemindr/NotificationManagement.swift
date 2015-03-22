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
    
    class var getInstance : NotificationManager
    {

        struct Static
        {
            static var instance: NotificationManager?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token)
        {
            Static.instance = NotificationManager()
        }
    
            return Static.instance!
    }
    
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
        
       /* var localNotification = UILocalNotification()
        
        for date in remdatelist{
        
            var localNotification = UILocalNotification()
            
            //localNotification.fireDate = NSDate(timeInterval: 3, sinceDate: date)
            
            
            localNotification.fireDate = NSDate(timeInterval: 3, sinceDate: fixNotificationDate(date))
            //localNotification.fireDate = fixNotificationDate(date)
            localNotification.alertBody = "Medication Alert: " + med.name + "!"
            localNotification.alertAction = "View"
            localNotification.category = "RemCat"
            
            UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        }*/
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
    
    /*
    * Converts the days bit mask to a boolean array
    */
    func getWeekdaysAsArray(reminder: Reminder) -> [Bool]? {
        
        if reminder.getRepeat() != Repeat.YES_WEEKLY {
            return nil
        }
        
        var dayBits = reminder.getDays()
        var returnArray : [Bool] = [false, false, false, false, false, false, false]
        
        for (var i = 0; i < Days.allValues.count; i++) {
            
            if((dayBits & 0x0001) == 1) {
                returnArray[i] = true
            }
            
            dayBits = (dayBits >> 1)
        }
        return returnArray;
    }

    
    /*
     * Gets the difference between the current day of the week and the next reminder day
     */
    func getDayIncreaseForWeekly(reminder: Reminder, referenceDateComponents: NSDateComponents) -> Int {
        var dayIncrease = 0;
        let weekdays = getWeekdaysAsArray(reminder)
        let weekday = referenceDateComponents.weekday - 1
        
        for index in (weekday + 1)...6 {
            if weekdays![index] {
                dayIncrease = index - (weekday)
                break
            }
        }
        
        if dayIncrease == 0 {
            for index in 0...(weekday - 1) {
                if weekdays![index] {
                    dayIncrease = 7 - weekday + index
                    break
                }
            }
        }
        
        if dayIncrease == 0 {
            dayIncrease = 7
        }
        
        return dayIncrease
    }
    
    
    /*
     * Gets the next time and date that reminder should occur
     */
    func getNextReminderDateAndTime(reminder: Reminder)->NSDate?{
        
        let gregorian = NSCalendar.currentCalendar()
        
        let currentDateAndTime = NSDate()
        
        let maskEverything = NSCalendarUnit.DayCalendarUnit | NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.YearCalendarUnit | NSCalendarUnit.HourCalendarUnit | NSCalendarUnit.MinuteCalendarUnit | NSCalendarUnit.SecondCalendarUnit | NSCalendarUnit.WeekdayCalendarUnit
        
        let todayComponents = gregorian.components(maskEverything, fromDate: currentDateAndTime)
        let startDateComponents = gregorian.components(maskEverything, fromDate: reminder.getStartDate())
        let currentMinutesFromMidnight = (todayComponents.hour * 60) + todayComponents.minute
        
        // We will be referencing today at midnight for ease of calculations
        todayComponents.hour = 0
        todayComponents.minute = 0
        todayComponents.second = 0
        
        // Store an NSDate representing today at midnight, and the current minutes from midnight
        let todayMidnight = gregorian.dateFromComponents(todayComponents)
       
        
        // Check if end date before today, if so no more reminders (return nil)
        if todayMidnight!.compare(reminder.getEndDate())  == .OrderedDescending && !reminder.getStartDate().isEqualToDate(reminder.getEndDate()) {
            return nil
        }
        
        if (reminder.getRepeat() == Repeat.NO) {
            
            // If start date is later in time, then next notification instance is the first time on the start date
            
            if todayMidnight!.compare(reminder.getStartDate())  == .OrderedAscending {
                let timeInterval: Int = 60 * Int(reminder.getTimes()[0])
                let nextNotificationDate = NSDate(timeInterval: NSTimeInterval(timeInterval), sinceDate: reminder.getStartDate())
                return nextNotificationDate
            }
            
            // If start date is today, check if any of the times are after now
            
            if todayMidnight!.compare(reminder.getStartDate())  == .OrderedSame {
                for time in reminder.getTimes() {
                    if currentMinutesFromMidnight < Int(time) {
                        let timeInterval = 60 * Int(time)
                        let nextNotificationDate = NSDate(timeInterval: NSTimeInterval(timeInterval), sinceDate: todayMidnight!)
                        return nextNotificationDate
                    }
                }
            }
            
            // If start day and all times have passed, no more reminders
            
            return nil
        }
            
        else if reminder.getRepeat() == Repeat.YES_CUSTOM {
            
            let differenceComponents = gregorian.components(NSCalendarUnit.DayCalendarUnit, fromDate: reminder.getStartDate(), toDate: todayMidnight!, options: nil)
            let dayDifference = differenceComponents.day
            
            // If start date is later in time, then next notification instance is the first time on the start date
            
            if dayDifference < 0 {
                let timeInterval = 60 * Int(reminder.getTimes()[0])
                let nextNotificationDate = NSDate(timeInterval: NSTimeInterval(timeInterval), sinceDate: reminder.getStartDate())
                return nextNotificationDate
            }
            
            var numberOfDaysAfterLastNotification = dayDifference % Int(reminder.getDays())
            
            // If reminder occurs today, check if any of the times are after now
            
            if numberOfDaysAfterLastNotification == 0 {
                for time in reminder.getTimes() {
                    if currentMinutesFromMidnight < Int(time) {
                        let timeInterval = (60 * Int(time))
                        let nextNotificationDate = NSDate(timeInterval: NSTimeInterval(timeInterval), sinceDate: todayMidnight!)
                        return nextNotificationDate
                    }
                }
            }
            
            // If reminder occurs after today, we need to find the next day it occurs
            
            let dayIncrease = Int(reminder.getDays()) - numberOfDaysAfterLastNotification
            
            // Because reminder is on a future day, the next time will always be the first time in the (ordered) array
            
            let timeInterval: Int = (86400 * dayIncrease) + (60 * Int(reminder.getTimes()[0]))
            let nextNotificationDate = NSDate(timeInterval: NSTimeInterval(timeInterval), sinceDate: todayMidnight!)
            
            if nextNotificationDate.compare(reminder.getEndDate())  == .OrderedDescending && !reminder.getStartDate().isEqualToDate(reminder.getEndDate())
            {
                return nil
            }
            else
            {
                return nextNotificationDate
            }
        }
            
        else if reminder.getRepeat() == Repeat.YES_WEEKLY {
            
            let weekdays = self.getWeekdaysAsArray(reminder)
            
            // Reference date is either today or start date, if start date is after today
            
            var referenceDate = todayMidnight
            var referenceDateComponents = todayComponents
            var minutesFromMidnight = currentMinutesFromMidnight
            
            if todayMidnight!.compare(reminder.getStartDate())  == .OrderedAscending {
                referenceDate = reminder.getStartDate()
                referenceDateComponents = startDateComponents
                minutesFromMidnight = 0
            }
            
            // If reminder occurs on reference date, check if any of the times are after the reference time
            
            if weekdays![referenceDateComponents.weekday - 1] {
                for time in reminder.getTimes() {
                    if minutesFromMidnight < Int(time) {
                        let timeInterval = (60 * Int(time))
                        let nextNotificationDate = NSDate(timeInterval: NSTimeInterval(timeInterval), sinceDate: referenceDate!)
                        return nextNotificationDate
                    }
                }
            }
            
            // If reminder occurs after reference day, we need to find the next day it occurs
            
            let dayIncrease = getDayIncreaseForWeekly(reminder, referenceDateComponents: referenceDateComponents)
            
            // Because reminder is on a future day, the next time will always be the first time in the (ordered) array
            
            let timeInterval = (86400 * dayIncrease) + (60 * Int(reminder.getTimes()[0]))
            let nextNotificationDate = NSDate(timeInterval: NSTimeInterval(timeInterval), sinceDate: referenceDate!)
            return nextNotificationDate
        }
        
        // We should never get here
        
        return nil
    }
    
    private init(){
        
        println("Creating singleton")
        
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


