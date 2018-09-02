//
//  CAAgendaViewModel.swift
//  CalendarAgenda
//
//  Created by Kevin on 2018-08-23.
//  Copyright © 2018 Kevin's Project. All rights reserved.
//

import UIKit

class CAAgendaViewModel {
    let minDate = Date(timeIntervalSinceNow: (-365 * 24 * 60 * 60)) // a year in the past
    let maxDate = Date(timeIntervalSinceNow: (365 * 24 * 60 * 60)) // a year in the future
    
    var eventList: [CAEvent] = []
    
    init() {
        let contact1 = CAContacts.init(userID: "123", userName: "abc", userIcon: "profilePic1")
        let contact2 = CAContacts.init(userID: "124", userName: "abd", userIcon: "profilePic2")
        let contact3 = CAContacts.init(userID: "125", userName: "abe", userIcon: "profilePic3")
        let event1 = CAEvent.init(eventID: "1",
                                  eventTitle: "Service appointment at BMW OF SAN FRANCISCO",
                                  eventStartTime: Date(),
                                  eventEndTime: Date(timeInterval: 60*60, since: Date()),
                                  stickerColor: "#1ee136",
                                  paticipants: [],
                                  eventLocation: "1675 HOWARD STREET, SAN FRANCISCO")
        
        let event2 = CAEvent.init(eventID: "2",
                                  eventTitle: "Outlook Mobile All Hands",
                                  eventStartTime: Date.yyyyMMddhhmmDate(dateString: "2018090114:00"),
                                  eventEndTime: Date.yyyyMMddhhmmDate(dateString: "2018090116:00"),
                                  stickerColor: "#02ca01",
                                  paticipants: [contact2, contact3],
                                  eventLocation: "Conf Room 1355 Market/3500")
        let event3 = CAEvent.init(eventID: "1",
                                  eventTitle: "Free Lunch & Speechless Madness!",
                                  eventStartTime: Date(),
                                  eventEndTime: Date(timeInterval: 60*60*24, since: Date()),
                                  stickerColor: "",
                                  paticipants: [contact1, contact2],
                                  eventLocation: "Mountain View, SVC-1 MPRs")
        
        eventList.append(event1)
        eventList.append(event2)
        eventList.append(event3)
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


