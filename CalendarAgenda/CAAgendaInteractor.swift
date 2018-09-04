//
//  CAAgendaInteractor.swift
//  CalendarAgenda
//
//  Created by Kevin on 2018-08-26.
//  Copyright © 2018 Kevin's Project. All rights reserved.
//

import UIKit

class CAAgendaInteractor: NSObject {
    var dataManager: CAEventDataControllable!
    init(dataManager: CAEventDataControllable) {
        self.dataManager = dataManager
    }
    
    func refreshData() -> CAAgendaViewModel {
        let storedEventList = dataManager.fetchEventList()
        return CAAgendaViewModel(eventList: storedEventList)
    }
}
