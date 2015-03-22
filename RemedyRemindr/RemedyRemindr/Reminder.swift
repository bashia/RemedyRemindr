//
//  Reminder.swift
//  RemedyRemindr
//
//  Created by Tony on 2015-02-09.
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
    private var nextInstance: NSDate?
    private var repeat : Repeat
    private var days : Int16
    private var times: [Int16]
    private var notes: String
    
    override init() {
        
        startDate = NSDate()
        endDate = NSDate()
        nextInstance = NSDate()
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
                if days == 0
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
    
    func getWeekdaysAsArray() -> [Bool]? {
        
        if repeat != Repeat.YES_WEEKLY {
            return nil
        }

        var dayBits = days
        var returnArray : [Bool] = [false, false, false, false, false, false, false]
        
        for (var i = 0; i < Days.allValues.count; i++) {
            
            if((dayBits & 0x0001) == 1) {
                returnArray[i] = true
            }
            
            dayBits = (dayBits >> 1)
        }
        return returnArray;
    }
    
    func getTimes() -> [Int16] {
        return times
    }
    
    private func getclosestMinute(nowday: NSDateComponents, remday: NSDateComponents)->NSDate?{
        
        if ((nowday.day == remday.day) &
            (nowday.month == remday.month) &
            (nowday.year == remday.year)){        //If now is the same day as the first instance
                for time in self.times.reverse(){
                    if nowday.minute<=Int(time){
                        var retdatecomps = remday
                        retdatecomps.minute = Int(time)
                        return retdatecomps.date
                    }
                }
        }
        else {
            var advance = nowday
            advance.day+=1
            return getclosestMinute(advance, remday: remday)
        }
        print("ERROR!")
        return nil //Should never happen
    }
    
    
    func getnextInstance()->NSDate? {
        return self.nextInstance
    }
    
    func popnextInstance()->NSDate?{    //Get next instance in time
        
        let gregorian = NSCalendar.currentCalendar()
        
        // GET NOW TIME
        let currentDateAndTime = NSDate()
        
        let maskEverything = NSCalendarUnit.DayCalendarUnit | NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.YearCalendarUnit | NSCalendarUnit.HourCalendarUnit | NSCalendarUnit.MinuteCalendarUnit | NSCalendarUnit.SecondCalendarUnit | NSCalendarUnit.WeekdayCalendarUnit
        
        let nowComponents = gregorian.components(maskEverything, fromDate: currentDateAndTime)
        
        let year = nowComponents.year
        let month = nowComponents.month
        let day = nowComponents.day
        let hour = nowComponents.hour
        let minute = nowComponents.minute
        let second = nowComponents.second
        let weekday = nowComponents.weekday - 1
        
        currentMinutesFromMidnight = (hour * 60) + minute
        nowComponents.hour = 0
        nowComponents.minute = 0
        nowComponents.second = 0
        
        // Check if end date before today, if so no more reminders (return nil)
        
        if (self.repeat == Repeat.NO) {
            return nil
        }
        else if self.repeat == Repeat.YES_CUSTOM {
            
            let maskStartDate = NSCalendarUnit.DayCalendarUnit | NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.YearCalendarUnit | NSCalendarUnit.HourCalendarUnit | NSCalendarUnit.MinuteCalendarUnit | NSCalendarUnit.SecondCalendarUnit
            
            let startDateComponents = gregorian.components(maskEverything, fromDate: self.startDate)
            startDateComponents.hour = 0
            startDateComponents.minute = 0
            startDateComponents.second = 0
            
            let startDateMidnight = gregorian.dateFromComponents(startDateComponents)
            let todayMidnight = gregorian.dateFromComponents(nowComponents)
            
            let differenceComponents = gregorian.components(NSCalendarUnit.DayCalendarUnit, fromDate: startDateMidnight!, toDate: todayMidnight!, options: nil)
            let dayDifference = differenceComponents.day
            
            let numberOfDaysAfterLastNotification = dayDifference % self.getDays()
            
            if numberOfDaysAfterLastNotification == 0 {
                    
                // Find next time of day, if possible
                
                for time in self.getTimes() {
                    if currentMinutesFromMidnight < time {
                        // this is definitely the next time
                        return nil
                    }
                }
            }
            else {
                timeInterval = (86400 * (self.getDays() - numberOfDaysAfterLastNotification)) + (60 * times[0])
                let nextNotificationDate = NSDate(timeInterval: NSTimeInterval(timeInterval), sinceDate: todayMidnight)
            }
            
        }
        else if self.repeat == Repeat.YES_WEEKLY {
            let weekdays = self.getWeekdaysAsArray()
            if weekdays[weekday] {
                
                // Find next time of day, if possible
                
                for time in self.getTimes() {
                    if currentMinutesFromMidnight < time {
                        // this is definitely the next time
                        return nil
                    }
                }
            }
            
            var dayIncrease = 0;
            
            // Make this whole next bit a nice function
            for index in (weekday + 1)...6 {
                if weekdays[index] {
                    dayIncrease = index - weekday
                }
            }
            
            if dayIncrease == 0 {
                for index in 0...(weekday - 1) {
                    if weekdays[index] {
                        dayIncrease = 6 - weekday + index
                    }
                }
            }
            
            if dayIncrease == 0 {
                dayIncrease = 7
            }
            
            timeInterval = (86400 * dayIncrease) + (60 * times[0])
            
            let todayMidnight = gregorian.dateFromComponents(nowComponents)
            let nextNotificationDate = NSDate(timeInterval: NSTimeInterval(timeInterval), sinceDate: todayMidnight)
            
        }
        
        return nil
        
        
        
        
        /*
        
        
        
        let gregorian = NSCalendar.currentCalendar()
        var curnextdate: NSDate = self.nextInstance!
        
        var curnextcomps = gregorian.components(.CalendarUnitHour | .CalendarUnitMinute | .CalendarUnitWeekday, fromDate: curnextdate)
        var a = curnextcomps.minute
        var b = curnextcomps.hour
        var curnextminute = 60*curnextcomps.hour + curnextcomps.minute
        if curnextminute != Int(self.times[self.times.count-1]) { //If current nextinstance is not the last one of its day
            var nexttimeindex = find(self.times,Int16(curnextminute))! + 1
            var minstonext = self.times[nexttimeindex]-curnextminute
            var olddate = self.nextInstance
            self.nextInstance = NSDate(timeInterval: NSTimeInterval(Int(minstonext) * 60), sinceDate: self.nextInstance!)
            return olddate
        }
        
        
        // This will ALWAYs crash when entering a non-repeating 
        if (self.repeat == Repeat.NO){
            return nil
        }
        else if self.repeat == Repeat.YES_WEEKLY{
            var currentweekday = curnextcomps.weekday
            var bitstring = String(self.days,radix: 2) //make binary array of days array
            var padded = bitstring
            for i in 0..<(7 - countElements(bitstring)) { //pad binary array to 7 bits
                bitstring = "0" + bitstring
            }
            var numdays:Int = 0
            for numdays = 1; numdays < 8; numdays++ { //numdays will always be less than or equal to 7
                var test = padded[(currentweekday + numdays-1)%7]
                if test == "1"{
                    break
                }
            }
            var oldnextdaycomp = gregorian.components(NSCalendarUnit.DayCalendarUnit, fromDate: self.nextInstance!)
            var oldnextday = gregorian.dateFromComponents(oldnextdaycomp) //NSDate from only the day component of nextday
            var newnextinst = NSDate(timeInterval: NSTimeInterval(Int(numdays*1440 + self.times[0]) * 60), sinceDate: oldnextday!)
            if (newnextinst.earlierDate(self.endDate) == self.endDate){
                var lastinst = self.nextInstance
                self.nextInstance = nil
                println("if")
                print(lastinst)
                return lastinst
            }
            else{
                var olddate = self.nextInstance
                self.nextInstance = newnextinst
                println("else")
                print(olddate)
                return olddate
            }
        }
        else if (self.repeat == Repeat.YES_CUSTOM){
            
            var oldnextdaycomp = gregorian.components(NSCalendarUnit.DayCalendarUnit | NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.YearCalendarUnit | NSCalendarUnit.HourCalendarUnit | NSCalendarUnit.MinuteCalendarUnit | NSCalendarUnit.SecondCalendarUnit, fromDate: self.nextInstance!)
            
            var oldnextday = gregorian.dateFromComponents(oldnextdaycomp) //NSDate from only the day component of nextday
            
            var newnextinst = NSDate(timeInterval: NSTimeInterval(Int(days*1440 + self.times[0]) * 60), sinceDate: oldnextday!)
            
            if (newnextinst.earlierDate(self.endDate) == self.endDate){
                var lastinst = self.nextInstance
                self.nextInstance = nil
                 println("in custom")
                return lastinst
            }
            else{
                self.nextInstance = newnextinst
                 println("in custom")
                return newnextinst
            }
        }
        else{
            return nil //ERROR!! ERROR!!
        }
        */
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
        self.startDate = date
    }
    
    func setEndDate(date: NSDate)  {
        self.endDate = date
    }
    
    func setRepeat(repeat: Repeat){
        return self.repeat = repeat
    }
    
    func setTimes(times: [Int16]) {
        self.times = times.sorted({(t1: Int16, t2: Int16) -> Bool in return t1 < t2})
        
        /*
        Tony delete
        
        
        let gregorian = NSCalendar(calendarIdentifier: NSGregorianCalendar)
        self.nextInstance = NSDate(timeInterval: NSTimeInterval(Int(self.times[0]) * 60), sinceDate: gregorian!.startOfDayForDate(self.startDate))*/
    }
    
    
    func setDays(days: Int16){
        self.days = days
    }
    
    func setNotes(notes: String) {
        self.notes = notes
    }

    /*
        Tony delete
    
    */
    func setnextInstance(instance: NSDate) {
        self.nextInstance = instance
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