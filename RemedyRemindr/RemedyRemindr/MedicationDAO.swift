//
//  MedicationList.swift
//  RemedyRemindr
//
//  Created by Tony on 2015-02-09.
//  Copyright (c) 2015 Group 4. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class MedicationDAO {

    class func getMedications() -> [Medication]? {
        
        var meds = [Medication]()
        
        // Fetch CoreData
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName:"Medication")
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        let sortDescriptors = [sortDescriptor]
        fetchRequest.sortDescriptors = sortDescriptors
        
        var error: NSError?
        
        let fetchedResults = managedContext.executeFetchRequest(fetchRequest, error: &error) as [NSManagedObject]?
        
        for managedMed in fetchedResults! {
            
            // TODO: Should create using a conversion method
            var med = Medication(name: managedMed.valueForKey("name") as String)
            
            for mangedRem in (managedMed.valueForKey("reminder") as NSSet) {
                med.reminders.append(NSManagedObjectToReminder(mangedRem as NSManagedObject))
            }
            
            meds.append(med)
        }
        
        return meds

    }
    
    class func insertMedication(medication: Medication) {
        
        let currentMeds = self.getMedications()! as [Medication]
        
        for med in currentMeds {
            if med.name == medication.name {
                var alert : UIAlertView = UIAlertView(title: "Medication Already Exists", message: "Medication " + medication.name + " has already been added", delegate: nil, cancelButtonTitle: "OK")
                    alert.show()
                return
            }
        }
        
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let med = medicationToNSManagedObject(medication, managedContext: managedContext);
        
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }
    }
    
    /* Error codes
     * 0: OK
     * 1: Duplicate
     * 2: Error
     */
    class func insertReminder(medication: Medication, reminder: Reminder) -> Int {
        
        for existRem in medication.reminders{
            if reminder.isEqual(existRem) {
                return 1
            }
        }
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let predicate = NSPredicate(format: "name = %@", medication.name)
        
        let fetchRequest = NSFetchRequest(entityName:"Medication")
        fetchRequest.predicate = predicate
        
        var error: NSError?
        let fetchedResults = managedContext.executeFetchRequest(fetchRequest, error: &error) as [NSManagedObject]?
        
        if fetchedResults?.count > 1
        {
            return 2
        }
        else
        {
            let rem = reminderToNSManagedObject(reminder, managedContext: managedContext)
            rem.setValue(fetchedResults![0], forKey: "medication")
            medication.reminders.append(reminder)
            
            var error: NSError?
            if !managedContext.save(&error) {
                println("Could not save \(error), \(error?.userInfo)")
                // Make a better message thing here
                return 2
            }
            else {
                return 0
            }
        }
    }
    
    /*class func getRemindersForMedication(medication :Medication) -> [Reminder]
    {
    
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let predicate = NSPredicate(format: "name = %@", medication.name)
        
        let fetchRequest = NSFetchRequest(entityName:"Medication")
        fetchRequest.predicate = predicate
        
        var error: NSError?
        let fetchedResults = managedContext.executeFetchRequest(fetchRequest, error: &error) as [NSManagedObject]?
        
        if fetchedResults?.count > 1
        {
            //error
        }
        else
        {
            var reminders = [Reminder]()
            for mangedRem in (fetchedResults![0].valueForKey("reminder") as NSSet) {
                reminders.append(NSManagedObjectToReminder(mangedRem as NSManagedObject))
            }
            
            return reminders
        }
        
        return [Remiders]()
        
    }*/
    
    class func deleteReminder(reminder: Reminder, medication :Medication) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let predicate = NSPredicate(format: "name = %@", medication.name)
        
        let fetchRequest = NSFetchRequest(entityName:"Medication")
        fetchRequest.predicate = predicate
        
        var error: NSError?
        let fetchedResults = managedContext.executeFetchRequest(fetchRequest, error: &error) as [NSManagedObject]?
        
        if fetchedResults?.count > 1
        {
            // error
        }
        else
        {
            for managedRem in (fetchedResults![0].valueForKey("reminder") as NSSet)
            {
                if(NSManagedObjectToReminder(managedRem as NSManagedObject).isEqual(reminder)) {
                    
                    managedContext.deleteObject(managedRem as NSManagedObject)
                    managedContext.save(nil)
                }
            }
        
        }
    }
    
    class func deleteMedication(medication: Medication){
       
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let predicate = NSPredicate(format: "name = %@", medication.name)
        
        let fetchRequest = NSFetchRequest(entityName:"Medication")
        fetchRequest.predicate = predicate
        
        var error: NSError?
        let fetchedResults = managedContext.executeFetchRequest(fetchRequest, error: &error) as [NSManagedObject]?

        if fetchedResults?.count > 1
        {
            // error
        }
        else
        {
            managedContext.deleteObject(fetchedResults![0])
            managedContext.save(nil)
        
        }
    
    }
    
    private class func medicationToNSManagedObject(medication: Medication, managedContext: NSManagedObjectContext) -> NSManagedObject {
    
        let entity = NSEntityDescription.entityForName("Medication", inManagedObjectContext:managedContext)
        let med = NSManagedObject(entity: entity!, insertIntoManagedObjectContext:managedContext)
        
        med.setValue(medication.name, forKey: "name")
        
        return med
    
    }
    
    private class func reminderToNSManagedObject(reminder: Reminder, managedContext: NSManagedObjectContext) -> NSManagedObject {
        
        let entity = NSEntityDescription.entityForName("Reminder", inManagedObjectContext:managedContext)
        let managedReminder = NSManagedObject(entity: entity!, insertIntoManagedObjectContext:managedContext)
        
        managedReminder.setValue(reminder.getStartDate(), forKey: "startDate")
        managedReminder.setValue(reminder.getEndDate(), forKey: "endDate")
        managedReminder.setValue(Int(reminder.getDays()), forKey: "days")
        managedReminder.setValue(reminder.getRepeat().rawValue, forKey: "repeat")
        managedReminder.setValue(reminder.getNotes(), forKey: "notes")
        
        
        var times : NSString = ""
        for time in reminder.getTimes()
        {
            times = times + String(time) + ";"
        }
        
        managedReminder.setValue(times, forKey: "times")
        return managedReminder
    }
    
    
    private class func NSManagedObjectToReminder(managedReminder: NSManagedObject) -> Reminder{
    
        var reminder = Reminder()
        reminder.setStartDate(managedReminder.valueForKey("startDate") as NSDate)
        reminder.setEndDate(managedReminder.valueForKey("endDate") as NSDate)
        reminder.setDays(Int16(managedReminder.valueForKey("days") as Int))
        reminder.setRepeat(Repeat(rawValue: managedReminder.valueForKey("repeat") as String)!)
        reminder.setNotes(managedReminder.valueForKey("notes") as String)
        
        var times: [Int16] = []
        let managedTimes = managedReminder.valueForKey("times") as String
        
        for time in (split(managedTimes){$0 == ";"}) {
            times.append(Int16(time.toInt()!))
        }
    
        reminder.setTimes(times)

        return reminder
        
    }
    
    
    

}