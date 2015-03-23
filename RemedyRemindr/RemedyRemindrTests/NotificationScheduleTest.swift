//
//  NotificationScheduleTest.swift
//  RemedyRemindr
//
//  Created by RemedyRemindr Team on 2015-03-22.
//  Copyright (c) 2015 Group 4. All rights reserved.
//

import UIKit
import XCTest

class NotifcationScheduleTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testNonRepeatingNotToday() {
        
        let startDate  = NSDate(timeInterval: 440*60, sinceDate: NSDate())
        let reminder = createSingleDayReminder(startDate, times: [1400])
        
        let scheduledDate = NotificationManager.getInstance.getNextReminderDateAndTime(reminder)
        let expectedDate = NSDate(timeInterval: NSTimeInterval(Int(reminder.getTimes()[0]) * 60), sinceDate:reminder.getStartDate())
        
        
        XCTAssertTrue(scheduledDate!.isEqualToDate(expectedDate), "testNonRepeatingNotToday: Schdeuled reminder was unexpected")
    }
    
    
    func testNonRepeatingIsTodayAfterFirstTime() {
        
        let startDate  = NSDate()
        
        let gregorian = NSCalendar.currentCalendar()
        let maskEverything = NSCalendarUnit.DayCalendarUnit | NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.YearCalendarUnit | NSCalendarUnit.HourCalendarUnit | NSCalendarUnit.MinuteCalendarUnit | NSCalendarUnit.SecondCalendarUnit
        let startDateComponents = gregorian.components(maskEverything, fromDate: startDate)
        let currentMinuteOfDay : Int = (startDateComponents.hour * 60) + startDateComponents.minute
        
        
        let times = [Int16(currentMinuteOfDay - 10), Int16(currentMinuteOfDay + 10)]
        
        let reminder = createSingleDayReminder(startDate, times: times)
        
        let scheduledDate = NotificationManager.getInstance.getNextReminderDateAndTime(reminder)
        let expectedDate = NSDate(timeInterval: NSTimeInterval(Int(reminder.getTimes()[1]) * 60), sinceDate:reminder.getStartDate())
        
        
        XCTAssertTrue(scheduledDate!.isEqualToDate(expectedDate), "testNonRepeatingIsTodayAfterFirstTime: Schdeuled reminder was unexpected")
    }
    
    func testNonRepeatingIsTodayAfterLastTime() {
        
        let startDate  = NSDate()
        
        let gregorian = NSCalendar.currentCalendar()
        let maskEverything = NSCalendarUnit.DayCalendarUnit | NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.YearCalendarUnit | NSCalendarUnit.HourCalendarUnit | NSCalendarUnit.MinuteCalendarUnit | NSCalendarUnit.SecondCalendarUnit
        let startDateComponents = gregorian.components(maskEverything, fromDate: startDate)
        let currentMinuteOfDay : Int = (startDateComponents.hour * 60) + startDateComponents.minute
        
        
        let times = [Int16(currentMinuteOfDay - 20), Int16(currentMinuteOfDay - 10)]
        
        let reminder = createSingleDayReminder(startDate, times: times)
        
        let scheduledDate = NotificationManager.getInstance.getNextReminderDateAndTime(reminder)
    
        XCTAssertTrue(scheduledDate == nil, "testNonRepeatingIsTodayAfterLastTime: Schdeuled reminder was unexpected")
    }
    
    func testWeeklyEndDateBeforeToday ()
    {
    
        let endDate = NSDate(timeInterval: NSTimeInterval(-1140 * 60), sinceDate: NSDate())
        let startDate = NSDate(timeInterval: NSTimeInterval(-1140 * 60 * 30), sinceDate: endDate)
        
        let reminder = createWeeklyReminder(startDate, end: endDate , times: [500, 700, 900] , days:[false, false, true, true, false, true, false])
        
        let scheduledDate = NotificationManager.getInstance.getNextReminderDateAndTime(reminder)
        
        XCTAssertTrue(scheduledDate == nil, "testWeeklyEndDateBeforeToday: Schdeuled reminder was unexpected")
    }
    
    func testWeeklyNotificationNotOnStartDate()
    {
        let startDate = NSDate(timeInterval: NSTimeInterval(1440 * 60 * 5), sinceDate: NSDate())
        
        let gregorian = NSCalendar.currentCalendar()
        let weekdayEverything = NSCalendarUnit.WeekdayCalendarUnit
        let startDateComponents = gregorian.components(weekdayEverything, fromDate: startDate)
        let weekday = startDateComponents.weekday
        
        var days = [false, false, false, false, false, false, false]
        days[(weekday + 1) % 7] = true
        
        let reminder = createWeeklyReminder(startDate, end: startDate , times: [500, 700, 900] , days:days)
        
        let scheduledDate = NotificationManager.getInstance.getNextReminderDateAndTime(reminder)
        let expectedDate = NSDate(timeInterval: NSTimeInterval((Int(reminder.getTimes()[0]) + (1440 * 2)) * 60), sinceDate:reminder.getStartDate())
        
        
        XCTAssertTrue(scheduledDate!.isEqualToDate(expectedDate), "testWeeklyNotificationNotOnStartDate: Schdeuled reminder was unexpected")
    
    }
    
    func testWeeklyNotificationOnStartDate()
    {
        let startDate = NSDate(timeInterval: NSTimeInterval(1440 * 60 * 5), sinceDate: NSDate())
        
        let gregorian = NSCalendar.currentCalendar()
        let weekdayEverything = NSCalendarUnit.WeekdayCalendarUnit
        let startDateComponents = gregorian.components(weekdayEverything, fromDate: startDate)
        let weekday = startDateComponents.weekday
        
        var days = [false, false, false, false, false, false, false]
        days[(weekday - 1) % 7] = true
        
        let reminder = createWeeklyReminder(startDate, end: startDate , times: [500, 700, 900] , days:days)
        
        let scheduledDate = NotificationManager.getInstance.getNextReminderDateAndTime(reminder)
        let expectedDate = NSDate(timeInterval: NSTimeInterval((Int(reminder.getTimes()[0]) * 60)), sinceDate:reminder.getStartDate())
        
        XCTAssertTrue(scheduledDate!.isEqualToDate(expectedDate), "testWeeklyNotificationOnStartDate: Schdeuled reminder was unexpected")
        
    }
    
    func testWeeklyAfterLastDailyReminder()
    {
    
        let startDate = NSDate(timeInterval: NSTimeInterval(1440 * 60 * (-10)), sinceDate: NSDate())
        
        let gregorian = NSCalendar.currentCalendar()
        
        let maskEverything = NSCalendarUnit.DayCalendarUnit | NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.YearCalendarUnit | NSCalendarUnit.HourCalendarUnit | NSCalendarUnit.MinuteCalendarUnit | NSCalendarUnit.SecondCalendarUnit | NSCalendarUnit.WeekdayCalendarUnit
        let todayComponents = gregorian.components(maskEverything, fromDate: NSDate())
        
        let weekday = todayComponents.weekday
        todayComponents.hour = 0
        todayComponents.minute = 0
        todayComponents.second = 0
        
        let todayMidnight = gregorian.dateFromComponents(todayComponents)
        
        var days = [false, false, false, false, false, false, false]
        days[(weekday - 1) % 7] = true
        days[(weekday + 1) % 7] = true
        
        let reminder = createWeeklyReminder(startDate, end: startDate , times: [0] , days:days)
        
        let scheduledDate = NotificationManager.getInstance.getNextReminderDateAndTime(reminder)
        let expectedDate = NSDate(timeInterval: NSTimeInterval((Int(reminder.getTimes()[0]) + (1440 * 2)) * 60), sinceDate: todayMidnight!)
        
        XCTAssertTrue(scheduledDate!.isEqualToDate(expectedDate), "testWeeklyAfterLastDailyReminder: Schdeuled reminder was unexpected")
    
    }
    
    func testWeeklyBeforeLastDailyReminder()
    {
        
        let startDate = NSDate(timeInterval: NSTimeInterval(1440 * 60 * (-10)), sinceDate: NSDate())
        
        let gregorian = NSCalendar.currentCalendar()
        
        let maskEverything = NSCalendarUnit.DayCalendarUnit | NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.YearCalendarUnit | NSCalendarUnit.HourCalendarUnit | NSCalendarUnit.MinuteCalendarUnit | NSCalendarUnit.SecondCalendarUnit | NSCalendarUnit.WeekdayCalendarUnit
        let todayComponents = gregorian.components(maskEverything, fromDate: NSDate())
        
        let weekday = todayComponents.weekday
        todayComponents.hour = 0
        todayComponents.minute = 0
        todayComponents.second = 0
        
        let todayMidnight = gregorian.dateFromComponents(todayComponents)
        
        var days = [false, false, false, false, false, false, false]
        days[(weekday - 1) % 7] = true
        days[(weekday + 1) % 7] = true
        
        let reminder = createWeeklyReminder(startDate, end: startDate , times: [0, 1439] , days:days)
        
        let scheduledDate = NotificationManager.getInstance.getNextReminderDateAndTime(reminder)
        let expectedDate = NSDate(timeInterval: NSTimeInterval(Int(reminder.getTimes()[1]) * 60), sinceDate: todayMidnight!)
        
        XCTAssertTrue(scheduledDate!.isEqualToDate(expectedDate), "testWeeklyBeforeLastDailyReminder: Schdeuled reminder was unexpected")
        
    }
    
    func testWeeklyStartDateIsToday()
    {
        
        let startDate = NSDate()
        
        let gregorian = NSCalendar.currentCalendar()
        
        let maskEverything = NSCalendarUnit.DayCalendarUnit | NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.YearCalendarUnit | NSCalendarUnit.HourCalendarUnit | NSCalendarUnit.MinuteCalendarUnit | NSCalendarUnit.SecondCalendarUnit | NSCalendarUnit.WeekdayCalendarUnit
        let todayComponents = gregorian.components(maskEverything, fromDate: NSDate())
        
        let weekday = todayComponents.weekday
        todayComponents.hour = 0
        todayComponents.minute = 0
        todayComponents.second = 0
        
        let todayMidnight = gregorian.dateFromComponents(todayComponents)
        
        var days = [false, false, false, false, false, false, false]
        days[(weekday - 1) % 7] = true
        
        let reminder = createWeeklyReminder(startDate, end: startDate , times: [1439] , days:days)
        
        let scheduledDate = NotificationManager.getInstance.getNextReminderDateAndTime(reminder)
        let expectedDate = NSDate(timeInterval: NSTimeInterval(Int(reminder.getTimes()[0]) * 60), sinceDate: todayMidnight!)
        
        XCTAssertTrue(scheduledDate!.isEqualToDate(expectedDate), "testWeeklyStartDateIsToday: Schdeuled reminder was unexpected")
        
    }
    
    func testWeeklyEndDateIsToday()
    {
        
        let startDate = NSDate(timeInterval: NSTimeInterval(1440 * 60 * (-10)), sinceDate: NSDate())
        let endDate = NSDate()
        
        let gregorian = NSCalendar.currentCalendar()
        
        let maskEverything = NSCalendarUnit.DayCalendarUnit | NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.YearCalendarUnit | NSCalendarUnit.HourCalendarUnit | NSCalendarUnit.MinuteCalendarUnit | NSCalendarUnit.SecondCalendarUnit | NSCalendarUnit.WeekdayCalendarUnit
        let todayComponents = gregorian.components(maskEverything, fromDate: endDate)
        
        let weekday = todayComponents.weekday
        todayComponents.hour = 0
        todayComponents.minute = 0
        todayComponents.second = 0
        
        let todayMidnight = gregorian.dateFromComponents(todayComponents)
        
        var days = [false, false, false, false, false, false, false]
        days[(weekday - 1) % 7] = true
        
        let reminder = createWeeklyReminder(startDate, end: endDate , times: [1439] , days:days)
        
        let scheduledDate = NotificationManager.getInstance.getNextReminderDateAndTime(reminder)
        let expectedDate = NSDate(timeInterval: NSTimeInterval(Int(reminder.getTimes()[0]) * 60), sinceDate: todayMidnight!)
        
        XCTAssertTrue(scheduledDate!.isEqualToDate(expectedDate), "testWeeklyEndDateIsToday: Schdeuled reminder was unexpected")
        
    }
    
    func testCustomEndDateBeforeToday()
    {
        
        let endDate = NSDate(timeInterval: NSTimeInterval(-1140 * 60), sinceDate: NSDate())
        let startDate = NSDate(timeInterval: NSTimeInterval(-1140 * 60 * 30), sinceDate: endDate)
        
        let reminder = createCustomReminder(startDate, end: endDate , times: [500, 700, 900] , days: 3)
        
        let scheduledDate = NotificationManager.getInstance.getNextReminderDateAndTime(reminder)
        
        XCTAssertTrue(scheduledDate == nil, "testCustomEndDateBeforeToday: Schdeuled reminder was unexpected")
    }
    
    
    func testCustomNotificationNotOnStartDate()
    {
        let startDate = NSDate(timeInterval: NSTimeInterval(1440 * 60 * 5), sinceDate: NSDate())
        
        let reminder = createCustomReminder(startDate, end: startDate , times: [500, 700, 900] , days: 3)
        
        let scheduledDate = NotificationManager.getInstance.getNextReminderDateAndTime(reminder)
        let expectedDate = NSDate(timeInterval: NSTimeInterval(Int(reminder.getTimes()[0]) * 60), sinceDate:reminder.getStartDate())
        
        
        XCTAssertTrue(scheduledDate!.isEqualToDate(expectedDate), "testWeeklyNotificationNotOnStartDate: Schdeuled reminder was unexpected")
    }
    
    func testCustomNotificationTodayAfterLastTime()
    {
        let startDate = NSDate(timeInterval: NSTimeInterval(1440 * 60 * (-6)), sinceDate: NSDate())
        
        let today = NSDate()
        
        let gregorian = NSCalendar.currentCalendar()
        
        let maskEverything = NSCalendarUnit.DayCalendarUnit | NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.YearCalendarUnit | NSCalendarUnit.HourCalendarUnit | NSCalendarUnit.MinuteCalendarUnit | NSCalendarUnit.SecondCalendarUnit | NSCalendarUnit.WeekdayCalendarUnit
        let todayComponents = gregorian.components(maskEverything, fromDate: today)
        
        let weekday = todayComponents.weekday
        todayComponents.hour = 0
        todayComponents.minute = 0
        todayComponents.second = 0

        let todayMidnight = gregorian.dateFromComponents(todayComponents)
        
        let reminder = createCustomReminder(startDate, end: startDate , times: [0] , days: 3)
        
        let scheduledDate = NotificationManager.getInstance.getNextReminderDateAndTime(reminder)
        let expectedDate = NSDate(timeInterval: NSTimeInterval((Int(reminder.getTimes()[0]) + (1440 * 3))  * 60), sinceDate:todayMidnight!)
        
        
        XCTAssertTrue(scheduledDate!.isEqualToDate(expectedDate), "testWeeklyNotificationNotOnStartDate: Schdeuled reminder was unexpected")
    }
    
    func testCustomNotificationTodayBeforeFirstTime()
    {
        let startDate = NSDate(timeInterval: NSTimeInterval(1440 * 60 * (-6)), sinceDate: NSDate())
        
        let today = NSDate()
        
        let gregorian = NSCalendar.currentCalendar()
        
        let maskEverything = NSCalendarUnit.DayCalendarUnit | NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.YearCalendarUnit | NSCalendarUnit.HourCalendarUnit | NSCalendarUnit.MinuteCalendarUnit | NSCalendarUnit.SecondCalendarUnit | NSCalendarUnit.WeekdayCalendarUnit
        let todayComponents = gregorian.components(maskEverything, fromDate: today)
        
        let weekday = todayComponents.weekday
        todayComponents.hour = 0
        todayComponents.minute = 0
        todayComponents.second = 0
        
        let todayMidnight = gregorian.dateFromComponents(todayComponents)
        
        let reminder = createCustomReminder(startDate, end: startDate , times: [1449] , days: 3)
        
        let scheduledDate = NotificationManager.getInstance.getNextReminderDateAndTime(reminder)
        let expectedDate = NSDate(timeInterval: NSTimeInterval(Int(reminder.getTimes()[0])  * 60), sinceDate:todayMidnight!)
        
        
        XCTAssertTrue(scheduledDate!.isEqualToDate(expectedDate), "testWeeklyNotificationNotOnStartDate: Schdeuled reminder was unexpected")
    }
    
    func testCustomNotificationDayAfterNotification()
    {
        let startDate = NSDate(timeInterval: NSTimeInterval(1440 * 60 * (-1)), sinceDate: NSDate())
        
        let today = NSDate()
        
        let gregorian = NSCalendar.currentCalendar()
        
        let maskEverything = NSCalendarUnit.DayCalendarUnit | NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.YearCalendarUnit | NSCalendarUnit.HourCalendarUnit | NSCalendarUnit.MinuteCalendarUnit | NSCalendarUnit.SecondCalendarUnit | NSCalendarUnit.WeekdayCalendarUnit
        let todayComponents = gregorian.components(maskEverything, fromDate: today)
        
        let weekday = todayComponents.weekday
        todayComponents.hour = 0
        todayComponents.minute = 0
        todayComponents.second = 0
        
        let todayMidnight = gregorian.dateFromComponents(todayComponents)
        
        let reminder = createCustomReminder(startDate, end: startDate , times: [200, 657, 900] , days: 3)
        
        let scheduledDate = NotificationManager.getInstance.getNextReminderDateAndTime(reminder)
        let expectedDate = NSDate(timeInterval: NSTimeInterval((Int(reminder.getTimes()[0]) + (1440 * 2))  * 60), sinceDate:todayMidnight!)
        
        
        XCTAssertTrue(scheduledDate!.isEqualToDate(expectedDate), "testWeeklyNotificationNotOnStartDate: Schdeuled reminder was unexpected")
    }

    
    func testCustomNotificationOccursOnEndDate()
    {
        let startDate = NSDate(timeInterval: NSTimeInterval(1440 * 60 * (-9)), sinceDate: NSDate())
        let endDate = NSDate()
        
        let reminder = createCustomReminder(startDate, end: endDate , times: [1439] , days: 3)
        
        let scheduledDate = NotificationManager.getInstance.getNextReminderDateAndTime(reminder)
        let expectedDate = NSDate(timeInterval: NSTimeInterval(Int(reminder.getTimes()[0]) * 60), sinceDate: reminder.getEndDate())
        
        
        XCTAssertTrue(scheduledDate!.isEqualToDate(expectedDate), "testWeeklyNotificationNotOnStartDate: Schdeuled reminder was unexpected")
    }
    
    
    func testCustomNotificationNotOccurOnEndDate()
    {
        let startDate = NSDate(timeInterval: NSTimeInterval(1440 * 60 * (-9)), sinceDate: NSDate())
        let endDate = NSDate()
        
        let reminder = createCustomReminder(startDate, end: endDate , times: [1439] , days: 4)
        
        let scheduledDate = NotificationManager.getInstance.getNextReminderDateAndTime(reminder)
    
        XCTAssertTrue(scheduledDate == nil, "testWeeklyNotificationNotOnStartDate: Schdeuled reminder was unexpected")
    }
    
    
    
    
    
    
    func makeWeeklyDays(values: [Bool]) -> Int16 {
        var dayBits = Int16(0)
        for i in 0...6 {
            dayBits = dayBits << 1
            var day : Int16 = values[6-i] ? 0x0001 : 0x0000
            dayBits = dayBits | day
        }
        return dayBits
    }
    
    func createWeeklyReminder(start: NSDate, end: NSDate, times: [Int16], days: [Bool]) -> Reminder {
        let reminder = Reminder()
        reminder.setDays(makeWeeklyDays(days))
        reminder.setRepeat(Repeat.YES_WEEKLY)
        reminder.setStartDate(start)
        reminder.setEndDate(end)
        reminder.setTimes(times)
        return reminder
    }
    
    func createSingleDayReminder(start: NSDate, times: [Int16]) -> Reminder {
        let reminder = Reminder()
        reminder.setDays(0)
        reminder.setRepeat(Repeat.NO)
        reminder.setStartDate(start)
        reminder.setEndDate(start)
        reminder.setTimes(times)
        return reminder
    }
    
    func createCustomReminder(start: NSDate, end: NSDate, times: [Int16], days: Int16) -> Reminder {
        let reminder = Reminder()
        reminder.setDays(days)
        reminder.setRepeat(Repeat.YES_CUSTOM)
        reminder.setStartDate(start)
        reminder.setEndDate(end)
        reminder.setTimes(times)
        return reminder
    }
    
    
    
}

