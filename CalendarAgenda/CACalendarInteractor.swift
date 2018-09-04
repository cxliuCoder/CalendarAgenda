//
//  CACalendarInteractor.swift
//  CalendarAgenda
//
//  Created by Kevin on 2018-08-26.
//  Copyright © 2018 Kevin's Project. All rights reserved.
//

import UIKit

class CACalendarInteractor: NSObject {
    var dataManager: CAEventDataControllable!
    init(dataManager: CAEventDataControllable) {
        self.dataManager = dataManager
    }
    
    func refreshData() -> CACalendarViewModel {
        let storedEventList = dataManager.fetchEventList()
        var eventDates:[Date] = []
        for event in storedEventList {
            let date = event.eventStartTime.yyyyMMMddDate()
            if eventDates.contains(date) == false {
                eventDates.append(date)
            }
        }
        return CACalendarViewModel(eventDates: eventDates)
    }
}
