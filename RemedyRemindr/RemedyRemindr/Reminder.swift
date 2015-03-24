//
//  Reminder.swift
//  RemedyRemindr
//
//  Created by RemedyRemindr Team on 2015-02-09.
//  Copyright (c) 2015 Group 4. All rights reserved.
//

import Foundation

extension String {  //Let strings be indexed with the subscript operator
    
    subscript (i: Int) -> Character {
        return self[advance(self.startIndex, i)]
    }
    
}

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
    internal var uuid: String
    
    override init() {
        uuid = NSUUID().UUIDString;
        startDate = NSDate()
        endDate = NSDate()
        repeat = Repeat.NO
        days = 1
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
                if days == 1
                {
                    return  "Every Day"
                
                }
                
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
    
    // Converts a time of day in "minutes from midnight" form to a string
    class func timeToString(time: Int16) -> String {
        var hour = time / 60
        var period = " AM"
        
        if(hour > 11) {
            period = " PM"
            hour = hour-12
        }
        
        hour = hour == 0 ? 12 : hour
        
        return String(hour)+":"+String(format: "%02d", time%60) + period
    }
    
    // Returns a string representation of the reminder's time array
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

        let gregorian = NSCalendar.currentCalendar()
        
        let maskEverything = NSCalendarUnit.DayCalendarUnit | NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.YearCalendarUnit | NSCalendarUnit.HourCalendarUnit | NSCalendarUnit.MinuteCalendarUnit | NSCalendarUnit.SecondCalendarUnit
        
        let startDateComponents = gregorian.components(maskEverything, fromDate: date)
        
        startDateComponents.hour = 0
        startDateComponents.minute = 0
        startDateComponents.second = 0
        
        let startDateMidnight = gregorian.dateFromComponents(startDateComponents)

        self.startDate = startDateMidnight!
    }
    
    func setEndDate(date: NSDate)  {
        
        let gregorian = NSCalendar.currentCalendar()
        
        let maskEverything = NSCalendarUnit.DayCalendarUnit | NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.YearCalendarUnit | NSCalendarUnit.HourCalendarUnit | NSCalendarUnit.MinuteCalendarUnit | NSCalendarUnit.SecondCalendarUnit
        
        let endDateComponents = gregorian.components(maskEverything, fromDate: date)
        
        endDateComponents.hour = 0
        endDateComponents.minute = 0
        endDateComponents.second = 0
        
        let endDateMidnight = gregorian.dateFromComponents(endDateComponents)
        
        self.endDate = endDateMidnight!
    }
    
    func setRepeat(repeat: Repeat){
        return self.repeat = repeat
    }
    
    func setTimes(times: [Int16]) {
        self.times = times.sorted({(t1: Int16, t2: Int16) -> Bool in return t1 < t2})
    }
    
    
    func setDays(days: Int16){
        self.days = days
    }
    
    func setNotes(notes: String) {
        self.notes = notes
    }
    
    // This is used to check if a reminder occurrs at the exact same date and times as another
    func toString() -> String {
        return getStartDateAsString() + getEndDateAsString() + getRepeatAsString() + getDaysAsString() + getTimesAsString()
    }
    
    override func isEqual(object: AnyObject?) -> Bool {
        return (object as Reminder).toString() == toString()
    }
    
    override var hash: Int {
        return toString().hashValue
    }


}