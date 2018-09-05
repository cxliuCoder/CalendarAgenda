//
//  CAPresenterTests.swift
//  CalendarAgendaTests
//
//  Created by Kevin on 2018-08-22.
//  Copyright © 2018 Kevin's Project. All rights reserved.
//

import XCTest
@testable import CalendarAgenda

class CAPresenterTests: XCTestCase {
    var presenter: CAPresenter!
    var calendarInteractor: CACalendarInteractor!
    var agendaInteractor: CAAgendaInteractor!
    var calendarView: CACalendarViewMock!
    var agendaView: CAAgendaViewMock!
    
    override func setUp() {
        super.setUp()
        calendarView = CACalendarViewMock()
        agendaView = CAAgendaViewMock()
        calendarInteractor = CACalendarInteractor(dataManager: CAEventDataManagerMock())
        agendaInteractor = CAAgendaInteractor(dataManager: CAEventDataManagerMock())
        presenter = CAPresenter(calInteractor: calendarInteractor, ageInteractor: agendaInteractor)
        presenter.calendarViewControlable = calendarView
        presenter.agendaViewControlable = agendaView
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testSelectToday() {
        presenter.selectToday()
        XCTAssertTrue(Date.isSameDate(date1: calendarView.selectedDate!, date2: Date()))
    }
    
    func testSelectADate() {
        let date = Date(timeInterval: 60*60, since: Date())
        presenter.selectDate(date: date)
        XCTAssertTrue(Date.isSameDate(date1: calendarView.selectedDate!, date2: date))
    }
    
    func testReloadData() {
        var calendarViewDidReload = false
        var aganendaViewDidReload = false
        presenter.reloadData()
        calendarViewDidReload = calendarView.didRefreshCalendar
        aganendaViewDidReload = agendaView.didRefreshAgenda
        XCTAssertTrue(calendarViewDidReload)
        XCTAssertTrue(aganendaViewDidReload)
    }
    
    
    
}
