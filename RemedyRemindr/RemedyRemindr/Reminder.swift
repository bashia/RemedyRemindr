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

enum Days: String {
    case SUN = "Sun"
    case MON = "Mon"
    case TUE = "Tue"
    case WED = "Wed"
    case THU = "Thu"
    case FRI = "Fri"
    case SAT = "Sat"

    static let allValues = [SUN, MON, TUE, WED, THU, FRI, SAT]
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
    
    func getStartDateAsString(style: NSDateFormatterStyle) -> String{
        let formatter = NSDateFormatter()
        formatter.dateStyle = style
        return formatter.stringFromDate(startDate)
    }
    
    func getStartDateAsString() ->String {
        return getStartDateAsString(NSDateFormatterStyle.ShortStyle)
    }
    
    func getEndDate() -> NSDate {
        return endDate
    }
    
    func getEndDateAsString(style: NSDateFormatterStyle) -> String{
        let formatter = NSDateFormatter()
        formatter.dateStyle = style
        return formatter.stringFromDate(endDate)
    }
    
    func getEndDateAsString() ->String {
        return getEndDateAsString(NSDateFormatterStyle.ShortStyle)
    }
    
    func getRepeat() -> Repeat {
        return repeat
    }
    
    func getRepeatAsString() -> String {
        return repeat.rawValue
    }
    
    func getDays() -> Int16 {
        return days
    }
    
    func getDaysAsString() -> String {
        switch(repeat){
            case Repeat.NO:
                return getStartDateAsString(NSDateFormatterStyle.LongStyle)
            
            case Repeat.YES_CUSTOM:
                return "Every " + String(Int(days)) + " days";
            
            case Repeat.YES_WEEKLY:
                
                var dayString = "Every "
                var dayBits = days
                
                for (var i = 0; i < Days.allValues.count; i++) {
                    
                    if((dayBits & 0x0001) == 1)
                    {
                        let seperator = dayString == "Every " ? "" : ", "
                        dayString = dayString + seperator + Days.allValues[i].rawValue
                    }
                    
                    dayBits = (dayBits >> 1)
                }
            
                return dayString;
        }
    }
    
    func getTimes() -> [Int16] {
        return times
    }
    
    class func timeToString(time: Int16) ->String
    {
        var hour = time / 60
        var period = " AM"
        
        if(hour > 11) {
            period = " PM"
            hour = hour-12
        }
        
        hour = hour == 0 ? 12 : hour
        
        return String(hour)+":"+String(format: "%02d", time%60) + period
    }
    
    func getTimesAsString() -> String {
        var timeString = ""
        
        for time in times {
        
            let seperator = timeString == "" ? "" : ", "
            
            timeString = timeString + seperator + Reminder.timeToString(time)
        }
        return timeString
    }
    
    func getNotesAsString() -> String {
        return notes
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