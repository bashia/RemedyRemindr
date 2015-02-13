//
//  Reminder.swift
//  RemedyRemindr
//
//  Created by Tony on 2015-02-09.
//  Copyright (c) 2015 Group 4. All rights reserved.
//

import Foundation

enum Repeat: String {
    case NO = "NO"
    case YES_WEEKLY = "YES_WEEKLY"
    case YES_CUSTOM = "YES_CUSTOM"
}

class Reminder: NSObject {
    
    private var startDate : NSDate
    private var endDate : NSDate
    private var repeat : Repeat
    private var days : Int16
    private var times: [Int16]
    private var notes: String
    
    override init() {
        startDate = NSDate()
        endDate = NSDate()
        repeat = Repeat.NO
        days = 0
        times = []
        notes = ""
    }
    
    func getStartDate() -> NSDate {
        return startDate
    }
    
    func getEndDate() -> NSDate {
        return endDate
    }
    
    func getRepeat() -> Repeat {
        return repeat
    }
    
    func getDays() -> Int16 {
        return days
    }
    
    func getTimes() -> [Int16] {
        return times
    }
    
    func getNotes() -> String {
        return notes
    }
    
    func setStartDate(date: NSDate){
        self.startDate = date
    }
    
    func setEndDate(date: NSDate)  {
        self.endDate = date
    }
    
    func setRepeat(repeat: Repeat){
        return self.repeat = repeat
    }
    
    func setDays(days: Int16){
        self.days = days
    }
    
    func setTimes(times: [Int16]) {
        self.times = times
    }
    
    func setNotes(notes: String) {
        self.notes = notes
    }
    
    


}