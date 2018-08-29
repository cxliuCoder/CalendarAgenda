//
//  CACalendarViewModel.swift
//  CalendarAgenda
//
//  Created by Kevin on 2018-08-26.
//  Copyright © 2018 Kevin's Project. All rights reserved.
//

import UIKit

class CACalendarViewModel: NSObject {
    let weekDayTitle = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    let monthTitle = ["", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    let minDate = Date(timeIntervalSinceNow: (-365 * 24 * 60 * 60)) // a year in the past
    let maxDate = Date(timeIntervalSinceNow: (365 * 24 * 60 * 60)) // a year in the future
    var eventDates: [Date] = [Date()]
    
    
    func hasEvent(date: Date) -> Bool {
        for aDate in eventDates {
            if Date.isSameDate(date1: date, date2: aDate) {
                return true
            }
        }
        return false
    }
}
