//
//  CAEventDataManager.swift
//  CalendarAgenda
//
//  Created by Kevin on 2018-08-23.
//  Copyright © 2018 Kevin's Project. All rights reserved.
//

protocol CAEventDataControllable {
    func fetcbEventList() -> [CAEvent]
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
            saveEventData(events: caEvents)
        }
    }
    
    init() {
        // initial load
        caEvents = refreshStoredEventData()
    }
    
    private func refreshStoredEventData() -> [CAEvent] {
        guard let data = caUserDefaults.value(forKey: Constants.CACalendarEventsKey) as? Data else {
            return []
        }
        
        let events = try! decoder.decode([CAEvent].self, from: data)
        return events
    }
    
    private func saveEventData(events:[CAEvent]) {
        let data = try! encoder.encode(events)
        caUserDefaults.set(data, forKey: Constants.CACalendarEventsKey)
    }
    
// MARK: - CAEventDataControllable
    
    func fetcbEventList() -> [CAEvent] {
        return caEvents
    }
    
    func add(event:CAEvent) {
        caEvents.append(event)
    }
    
    func remove(index: Int) {
        caEvents.remove(at: index)
    }
}

extension CAEventDataManager {
    struct Constants {
        static let CACalendarEventsKey = "CACalendarEventsKey"
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
