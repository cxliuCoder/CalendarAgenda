//
//  CAAgendaViewModel.swift
//  CalendarAgenda
//
//  Created by Kevin on 2018-08-23.
//  Copyright © 2018 Kevin's Project. All rights reserved.
//

import UIKit

class CAAgendaViewModel: NSObject {
    let minDate = Date(timeIntervalSinceNow: (-365 * 24 * 60 * 60)) // a year in the past
    let maxDate = Date(timeIntervalSinceNow: (365 * 24 * 60 * 60)) // a year in the future
    
    var eventList: [CAEvent] = []
    
    override init() {
        eventList = []
    }
    
    init(eventList: [CAEvent]) {
        self.eventList = eventList
    }
    
    func events(forDate: Date) -> [CAEvent] {
        var events: [CAEvent] = []
        for event in eventList {
            if Date.isSameDate(date1: event.eventStartTime, date2: forDate) {
                events.append(event)
            }
        }
        return events
    }
}


