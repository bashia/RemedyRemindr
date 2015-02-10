//
//  Medication.swift
//  RemedyRemindr
//
//  Created by Tony on 2015-02-08.
//  Copyright (c) 2015 Group 4. All rights reserved.
//

import Foundation
import CoreData

class Medication: NSObject {
    var name: String
    var reminders: [Reminder]
    
    init(name: String) {
        self.name = name
        reminders = []
    }
}