//
//  LogEntry.swift
//  RemedyRemindr
//
//  Created by RemedyRemindr Team on 2015-03-10.
//  Copyright (c) 2015 Group 4. All rights reserved.
//

import Foundation

class LogEntry: NSObject {
    private var date: NSDate
    private var text: String
    private var feeling: Float
    
    init(date:NSDate, text:String, feeling:Float){
        self.date = date
        self.text = text
        self.feeling = feeling
    }

    func getDate() -> NSDate{
        return date
    }
    
    func getDateAsString() -> String{
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.MediumStyle
        formatter.timeStyle = NSDateFormatterStyle.MediumStyle
        return formatter.stringFromDate(date)
    }
    
    func getText() -> String{
        return text
    }
    
    func getFeeling() -> Float{
        return feeling
    }
    
    func setDate(date:NSDate){
        self.date = date
    }
    
    func setText(text:String){
        self.text = text
    }
    
    func setFeeling(feeling:Float){
        self.feeling = feeling
    }

}