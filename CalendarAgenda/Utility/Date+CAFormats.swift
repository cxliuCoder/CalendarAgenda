//
//  Date+CAFormats.swift
//  CalendarAgenda
//
//  Created by Kevin on 2018-08-28.
//  Copyright © 2018 Kevin's Project. All rights reserved.
//

import Foundation

extension Date {
    static func daysBetween(fromDate:Date, toDate:Date) -> Int {
        let components1 = Calendar.current.dateComponents([.year,.month,.day], from: fromDate)
        let components2 = Calendar.current.dateComponents([.year,.month,.day], from: toDate)
        let components = Calendar.current.dateComponents([.day], from: components1, to: components2)
        return components.day ?? 0
    }
    
    static func durationBetween(fromDate:Date, toDate:Date) -> String {
        let components1 = Calendar.current.dateComponents([.year,.month,.day, .hour, .minute], from: fromDate)
        let components2 = Calendar.current.dateComponents([.year,.month,.day, .hour, .minute], from: toDate)
        var components = Calendar.current.dateComponents([.day], from: components1, to: components2)
        let days = components.day ?? 0
        components = Calendar.current.dateComponents([.hour], from: components1, to: components2)
        let hours = components.hour ?? 0
        components = Calendar.current.dateComponents([.minute], from: components1, to: components2)
        let mins = components.minute ?? 0
        
        var durationString = ""
        if days != 0 {
            if days == 1 {
                durationString = "Whole Day"
            } else {
                durationString = "\(days) Days"
            }
        } else if hours != 0 {
            durationString = "\(hours) Hours"
        } else {
            durationString = "\(mins) Hours"
        }
        
        return durationString
    }
    
    static func weekDay(fromDate: Date) -> Int {
        let components = Calendar.current.dateComponents([.weekday], from: fromDate)
        return components.weekday ?? 1
    }
    
    static func month(fromDate: Date) -> Int {
        let components = Calendar.current.dateComponents([.month], from: fromDate)
        return components.month ?? 1
    }
    
    static func day(fromDate: Date) -> Int {
        let components = Calendar.current.dateComponents([.day], from: fromDate)
        return components.day ?? 1
    }
    
    static func isSameDate(date1: Date, date2: Date) -> Bool {
        let components1 = Calendar.current.dateComponents([.year,.month,.day], from: date1)
        let components2 = Calendar.current.dateComponents([.year,.month,.day], from: date2)
        
        if components1.year == components2.year &&
            components1.month == components2.month &&
            components1.day == components2.day {
            return true
        } else {
            return false
        }
    }
    
    static func yyyyMMddhhmmDate(dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHH:mm"
        return dateFormatter.date(from: dateString)!
    }
    
    func timeOfDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm a"
        return dateFormatter.string(from: self)
    }
    
    func EEEEMMMMMddString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM dd"
        return dateFormatter.string(from: self)
    }
}
