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
        let components = Calendar.current.dateComponents([.day], from: fromDate, to:toDate)
        return components.day ?? 0
    }
    
    static func weekDay(fromDate: Date) -> Int {
        let components = Calendar.current.dateComponents([.weekday], from: fromDate)
        return components.weekday ?? 1
    }
    
    static func month(fromDate: Date) -> Int {
        let components2 = Calendar.current.dateComponents([.month], from: fromDate)
        return components2.month ?? 1
    }
    
    static func day(fromDate: Date) -> Int {
        let components2 = Calendar.current.dateComponents([.day], from: fromDate)
        return components2.day ?? 1
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
}
