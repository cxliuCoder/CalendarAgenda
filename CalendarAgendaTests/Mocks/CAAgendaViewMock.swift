//
//  CAAgendaViewMock.swift
//  CalendarAgendaTests
//
//  Created by Kevin on 2018-09-05.
//  Copyright © 2018 Kevin's Project. All rights reserved.
//

import UIKit
@testable import CalendarAgenda

class CAAgendaViewMock: CAAgendaControlable {
    var topedDate: Date!
    var didRefreshAgenda = false
    
    func top(date: Date) {
        topedDate = date
    }
    
    func refreshAgenda(viewModel: CAAgendaViewModel) {
        didRefreshAgenda = true
    }
}
