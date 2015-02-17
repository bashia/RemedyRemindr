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

    /*
     * Retrieves all medications from the data store and returns them in an array of Medication objects, sorted alphabetically by name
     * Returns nil if there is an error retrieving the medications
     */
    class func getMedications() -> [Medication]? {
        
        var meds = [Medication]()
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName:"Medication")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        let sortDescriptors = [sortDescriptor]
        fetchRequest.sortDescriptors = sortDescriptors
        
        // Fetch medication objects from data store
        var error: NSError?
        if let fetchedResults = managedContext.executeFetchRequest(fetchRequest, error: &error) as [NSManagedObject]? {
        
            // Convert medication data objects into Medication objects
            for managedMed in fetchedResults {
                var med = Medication(name: managedMed.valueForKey("name") as String)
                for mangedRem in (managedMed.valueForKey("reminder") as NSSet) {
                    med.reminders.append(NSManagedObjectToReminder(mangedRem as NSManagedObject))
                }
                meds.append(med)
            }
        } else {
            println("Error retrieving medications: \(error), \(error?.userInfo)")
            return nil
        }
        return meds

    }
    
    /*
    * Retrieves the NSManagedObject for a given medication name from the data store
    * Returns nil if the medication doesn't exist or there are duplicates (which is not allowed)
    */
    class func getMedicationObjectByName(name: String) -> NSManagedObject? {
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let predicate = NSPredicate(format: "name = %@", name)
        let fetchRequest = NSFetchRequest(entityName:"Medication")
        fetchRequest.predicate = predicate
        
        var error: NSError?
        if let fetchedResults = managedContext.executeFetchRequest(fetchRequest, error: &error) as [NSManagedObject]? {
            if fetchedResults.count != 1 {
                println("Error finding medication named " + name + ": Found " + String(fetchedResults.count))
                return nil
            }
            else {
                return fetchedResults[0]
            }
        }
        else {
            println("Error retrieving medication named " + name + ": \(error), \(error?.userInfo)")
            return nil
        }
    }
    
    /*
     * Inserts a Medication object into the data store
     * Returns nil if there is an error retrieving the medication list or inserting the medication
     * Returns false if a medication with the same name already exists
     */
    class func insertMedication(medication: Medication) -> Bool? {
        
        if let currentMeds = self.getMedications() {
        
            for med in currentMeds {
                if med.name == medication.name {
                    return false
                }
            }
            
            let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
            let managedContext = appDelegate.managedObjectContext!
            
            let med = medicationToNSManagedObject(medication, managedContext: managedContext);
            
            var error: NSError?
            if !managedContext.save(&error) {
                println("Error saving data: \(error), \(error?.userInfo)")
                return nil
            }
        }
        else {
            println("Could not insert medication due to error retrieving medication list.")
            return nil
        }
        return true
    }
    
    /*
    * Inserts a given Reminder object into the data store for a given Medication object
    * Returns nil if there is an error
    * Returns false if a reminder with the same configuration exists for the medication already
    */
    class func insertReminder(medication: Medication, reminder: Reminder) -> Bool? {
        
        for existRem in medication.reminders{
            if reminder.isEqual(existRem) {
                return false
            }
        }
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        if let medicationObject = getMedicationObjectByName(medication.name) {
            let rem = reminderToNSManagedObject(reminder, managedContext: managedContext)
            rem.setValue(medicationObject, forKey: "medication")
            medication.reminders.append(reminder)
                
            var error: NSError?
            if !managedContext.save(&error) {
                println("Error saving data: \(error), \(error?.userInfo)")
                return nil
            } else {
                return true
            }
        }
        else {
            println("Error: Could not insert reminder.")
            return nil
        }
    }
    
    /*
    * Deletes a Reminder object for a given Medication object from the data store
    * Returns nil if there is an error or if the reminder is not found
    */
    class func deleteReminder(reminder: Reminder, medication :Medication) -> Bool? {
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        if let medicationObject = getMedicationObjectByName(medication.name) {
            for managedRem in (medicationObject.valueForKey("reminder") as NSSet)
            {
                if(NSManagedObjectToReminder(managedRem as NSManagedObject).isEqual(reminder)) {
                    managedContext.deleteObject(managedRem as NSManagedObject)
                    var error: NSError?
                    if !managedContext.save(&error) {
                        println("Error saving data: \(error), \(error?.userInfo)")
                        return nil
                    } else {
                        return true
                    }
                }
            }
            return nil
        }
        else {
            println("Error: could not delete reminder.")
            return nil
        }
    }
    
    /*
    * Deletes a Medication object from the data store
    * Returns nil if there is an error or if the medication is not found
    */
    class func deleteMedication(medication: Medication) -> Bool? {
       
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedContext = appDelegate.managedObjectContext!

        if let medicationObject = getMedicationObjectByName(medication.name) {
            managedContext.deleteObject(medicationObject)
            var error: NSError?
            if !managedContext.save(&error) {
                println("Error saving data: \(error), \(error?.userInfo)")
                return nil
            } else {
                return true
            }
        }
        else {
            println("Error: Could not delete medication.")
            return nil
        }
    }
    
    /*
    * Converts a Medication object into an NSManagedObject representation of the medication
    */
    private class func medicationToNSManagedObject(medication: Medication, managedContext: NSManagedObjectContext) -> NSManagedObject {
    
        let entity = NSEntityDescription.entityForName("Medication", inManagedObjectContext:managedContext)
        let med = NSManagedObject(entity: entity!, insertIntoManagedObjectContext:managedContext)
        
        med.setValue(medication.name, forKey: "name")
        
        return med
    }
    
    /*
    * Converts a Reminder object into an NSManagedObject representation of the reminder
    */
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
    
    /*
    * Converts an NSManagedObject to a Reminder object
    */
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