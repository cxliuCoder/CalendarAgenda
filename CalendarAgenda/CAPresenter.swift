//
//  CAPresenter.swift
//  CalendarAgenda
//
//  Created by Kevin on 2018-08-26.
//  Copyright © 2018 Kevin's Project. All rights reserved.
//

import UIKit

protocol CAPresenterUpdatable {
    func selectToday()
    func selectDate(date: Date)
    func reloadData()
}

class CAPresenter: NSObject, CAPresenterUpdatable {
    
    var calendarInteractor: CACalendarInteractor!
    var calendarViewControlable: CACalendarControlable!
    var agendaInteractor: CAAgendaInteractor!
    var agendaViewControlable: CAAgendaControlable!
    
    var calendarViewModel: CACalendarViewModel! {
        didSet {
            calendarViewControlable.refreshCalendar(viewModel: calendarViewModel)
        }
    }
    var agendaViewModel: CAAgendaViewModel! {
        didSet {
            agendaViewControlable.refreshAgenda(viewModel: agendaViewModel)
        }
    }
    
    init(calInteractor: CACalendarInteractor, ageInteractor: CAAgendaInteractor) {
        calendarInteractor = calInteractor
        agendaInteractor = ageInteractor
    }
    
    
    // MARK: CACalendarPresenterUpdatable
    
    func selectToday() {
        selectDate(date: Date())
    }
    
    func selectDate(date: Date) {
        calendarViewControlable.showSelect(date: date)
        agendaViewControlable.top(date: date)
    }
    
    func reloadData() {
        calendarViewModel = calendarInteractor.refreshData()
        agendaViewModel = agendaInteractor.refreshData()
    }
}
