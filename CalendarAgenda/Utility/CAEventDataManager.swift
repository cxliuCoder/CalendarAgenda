//
//  CAEventDataManager.swift
//  CalendarAgenda
//
//  Created by Kevin on 2018-08-23.
//  Copyright © 2018 Kevin's Project. All rights reserved.
//

protocol CAEventDataControllable {
    func fetchEventList() -> [CAEvent]
    func add(event: CAEvent)
    func remove(index: Int)
}

import UIKit

class CAEventDataManager: CAEventDataControllable {
    static let sharedInstance = CAEventDataManager()
    
    let caUserDefaults = UserDefaults.standard
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    var caEvents: [CAEvent] = [] {
        didSet {
            saveEventData()
        }
    }
    
    init() {
        // initial load
        caEvents = refreshStoredEventData()
    }
    
    private func refreshStoredEventData() -> [CAEvent] {
        var events: [CAEvent] = []
        if let data = caUserDefaults.value(forKey: Constants.CACalendarEventsKey) as? Data {
            events = try! decoder.decode([CAEvent].self, from: data)
        }
        
        return events
    }
    
    func addDefaultData() {
        let event1 = CAEvent.init(eventID: "1",
                                  eventTitle: "Service appointment at BMW OF SAN FRANCISCO",
                                  eventStartTime: Date(),
                                  eventEndTime: Date(timeInterval: 60*60, since: Date()),
                                  stickerColor: "#1ee136",
                                  paticipants: [],
                                  eventLocation: "1675 HOWARD STREET, SAN FRANCISCO")
        
        let event2 = CAEvent.init(eventID: "2",
                                  eventTitle: "Outlook Mobile All Hands",
                                  eventStartTime: Date(timeInterval: -24*60*60, since: Date()),
                                  eventEndTime: Date(timeInterval: -24*60*60 + 15*60, since: Date()),
                                  stickerColor: "#02ca01",
                                  paticipants: [Constants.contact2, Constants.contact3],
                                  eventLocation: "Conf Room 1355 Market/3500")
        let event3 = CAEvent.init(eventID: "1",
                                  eventTitle: "Free Lunch & Speechless Madness!",
                                  eventStartTime: Date(),
                                  eventEndTime: Date(timeInterval: 60*60*24, since: Date()),
                                  stickerColor: "",
                                  paticipants: [Constants.contact1, Constants.contact2],
                                  eventLocation: "Mountain View, SVC-1 MPRs")
        
        add(event: event1)
        add(event: event2)
        add(event: event3)
    }
    
    private func saveEventData() {
        let data = try! encoder.encode(caEvents)
        caUserDefaults.set(data, forKey: Constants.CACalendarEventsKey)
    }
    
// MARK: - CAEventDataControllable
    
    func fetchEventList() -> [CAEvent] {
        return caEvents
    }
    
    func add(event:CAEvent) {
        caEvents.append(event)
        saveEventData()
    }
    
    func remove(index: Int) {
        caEvents.remove(at: index)
    }
    
    // random a Event in the next 20 days with random duration and random paticipants
    func addRandomEvent() {
        
        let contacts = [Constants.contact1, Constants.contact2, Constants.contact3]
        let day = String(format: "%02i", randomInt(30))
        let randomStartTime = Date.yyyyMMddhhmmDate(dateString: "201809\(day)06:00")
        
        var paticipants: [CAContacts] = []
        for i in 0 ..< randomInt(3) {
            paticipants.append(contacts[i])
        }
        
        let event = CAEvent.init(eventID: "\(randomInt(1000))",
                                 eventTitle: "This is a Random Event...",
                                 eventStartTime: randomStartTime,
                                 eventEndTime: Date(timeInterval: TimeInterval(randomInt(3*60*60)), since: randomStartTime),
                                 stickerColor: "#02ca01",
                                 paticipants: paticipants,
                                 eventLocation: "In a ramdon location...")
        add(event: event)
    }
    
    // a random int from 0 to max
    func randomInt(_ max: Int) -> Int{
        return Int(arc4random()) % max + 1
    }
}

extension CAEventDataManager {
    struct Constants {
        static let CACalendarEventsKey = "CACalendarEventsKey"
        static let contact1 = CAContacts.init(userID: "123", userName: "abc", userIcon: "profilePic1")
        static let contact2 = CAContacts.init(userID: "124", userName: "abd", userIcon: "profilePic2")
        static let contact3 = CAContacts.init(userID: "125", userName: "abe", userIcon: "profilePic3")
    }
}

struct CAEvent: Codable {
    var eventID: String
    var eventTitle: String
    var eventStartTime: Date
    var eventEndTime: Date
    var stickerColor: String
    var paticipants: [CAContacts]
    var eventLocation: String
}

struct CAContacts: Codable {
    var userID: String
    var userName: String
    var userIcon: String
}
