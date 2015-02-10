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

class MedicationList {

    class func fetchData() -> [Medication]? {
        
        var meds = [Medication]()
        
        // Fetch CoreData
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedContext = appDelegate.managedObjectContext!

        let fetchRequest = NSFetchRequest(entityName:"Medication")
        
        var error: NSError?
        
        let fetchedResults = managedContext.executeFetchRequest(fetchRequest, error: &error) as [NSManagedObject]?
        
        for med in fetchedResults! {
            
            var m = Medication(name: med.valueForKey("name") as String)
            let reminders = med.valueForKey("reminder") as NSSet
            
            for r in reminders{
                print(r.valueForKey("time"))
            }
            
        }
        
        return meds

    }
    
    class func insertData(medication: Medication) -> NSManagedObject {
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let entity = NSEntityDescription.entityForName("Medication", inManagedObjectContext:managedContext)
        let reminder = NSEntityDescription.entityForName("Reminder", inManagedObjectContext:managedContext)
        
        let med = NSManagedObject(entity: entity!, insertIntoManagedObjectContext:managedContext)
        let rem = NSManagedObject(entity: reminder!, insertIntoManagedObjectContext:managedContext)
        
        med.setValue(medication.name, forKey: "name")
        rem.setValue(123, forKey: "time")
        rem.setValue(med, forKey: "medication")
        
        
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }
        
        return med
    }
    
    
    

}