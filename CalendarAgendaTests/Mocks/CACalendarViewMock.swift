//
//  CACalendarViewMock.swift
//  CalendarAgendaTests
//
//  Created by Kevin on 2018-09-05.
//  Copyright © 2018 Kevin's Project. All rights reserved.
//

import UIKit
@testable import CalendarAgenda

class CACalendarViewMock: CACalendarControlable {
    var selectedDate: Date!
    var didRefreshCalendar = false
    
    func showSelect(date: Date) {
        selectedDate = date
    }
    
    func refreshCalendar(viewModel: CACalendarViewModel) {
        didRefreshCalendar = true
    }
}
