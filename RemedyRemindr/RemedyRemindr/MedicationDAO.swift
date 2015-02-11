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

    class func fetchData() -> [Medication]? {
        
        var meds = [Medication]()
        
        // Fetch CoreData
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedContext = appDelegate.managedObjectContext!

        let fetchRequest = NSFetchRequest(entityName:"Medication")
        
        var error: NSError?
        
        let fetchedResults = managedContext.executeFetchRequest(fetchRequest, error: &error) as [NSManagedObject]?
        
        for med in fetchedResults! {
            
            var newMed = Medication(name: med.valueForKey("name") as String)
            
            
            let reminders = med.valueForKey("reminder") as NSSet
            
            for r in reminders {
                // append reminder into med
                var newRem = Reminder(time: Int16(r.valueForKey("time") as Int))
                newMed.reminders.append(newRem)
            }
            meds.append(newMed)
        }
        
        return meds

    }
    
    class func insertData(medication: Medication) {
        
       let currentMeds = self.fetchData()! as [Medication]
        
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
    
    class func insertReminder(){
        /*let reminder = NSEntityDescription.entityForName("Reminder", inManagedObjectContext:managedContext)
        let rem = NSManagedObject(entity: reminder!, insertIntoManagedObjectContext:managedContext)
        rem.setValue(123, forKey: "time")
        rem.setValue(med, forKey: "medication")*/
    }
    
    class func deleteData(medication: Medication){
       
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
    
    
    

}