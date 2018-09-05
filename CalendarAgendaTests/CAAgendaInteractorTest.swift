//
//  CAAgendaInteractorTest.swift
//  CalendarAgendaTests
//
//  Created by Kevin on 2018-09-04.
//  Copyright © 2018 Kevin's Project. All rights reserved.
//

import XCTest
@testable import CalendarAgenda

class CAAgendaInteractorTest: XCTestCase {
    let sampleCAEvent = CAEvent(eventID: "sample", eventTitle: "", eventStartTime: Date(), eventEndTime: Date(), stickerColor: "", paticipants: [], eventLocation: "")
    let sampleCAEvent2 = CAEvent(eventID: "sample2", eventTitle: "", eventStartTime: Date(), eventEndTime: Date(), stickerColor: "", paticipants: [], eventLocation: "")
    let sampleCAEvent3 = CAEvent(eventID: "sample3", eventTitle: "", eventStartTime: Date(), eventEndTime: Date(), stickerColor: "", paticipants: [], eventLocation: "")
    let dataManagerMock = CAEventDataManagerMock()
    var ageInteractor: CAAgendaInteractor!
    var resultViewModel: CAAgendaViewModel!
    
    override func setUp() {
        super.setUp()
        
        dataManagerMock.add(event: sampleCAEvent)
        dataManagerMock.add(event: sampleCAEvent2)
        dataManagerMock.add(event: sampleCAEvent3)
        ageInteractor = CAAgendaInteractor(dataManager: dataManagerMock)
        
        resultViewModel = ageInteractor.refreshData()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testEventsCount() {
        let event = resultViewModel.events(forDate: Date())
        XCTAssertEqual(event.count, 3)
    }
    
    func testEventAfterModelChange() {
        dataManagerMock.remove(index: 0)
        resultViewModel = ageInteractor.refreshData()
        let event = resultViewModel.events(forDate: Date())
        XCTAssertEqual(event.count, 2)
    }
    
}
