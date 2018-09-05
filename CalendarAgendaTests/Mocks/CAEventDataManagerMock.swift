//
//  CAEventDataManagerMock.swift
//  CalendarAgendaTests
//
//  Created by Kevin on 2018-09-04.
//  Copyright © 2018 Kevin's Project. All rights reserved.
//

import UIKit
@testable import CalendarAgenda

class CAEventDataManagerMock: CAEventDataControllable {
    var eventList: [CAEvent] = []
    
    func fetchEventList() -> [CAEvent] {
        return eventList
    }
    
    func add(event: CAEvent) {
        eventList.append(event)
    }
    
    func remove(index: Int) {
        eventList.remove(at: index)
    }
}
