//
//  Tracker.swift
//  Tracker
//
//  Created by Lolita Chernysheva on 10.02.2024.
//  
//

import UIKit

struct Tracker {
    let id: UUID
    let title: String
    let color: UIColor
    let emogi: String
    let schedule: Schedule
}

struct Schedule {
    var weekdays: [Weekday]
    
    mutating func addWeekday(_ weekday: Weekday) {
        if !weekdays.contains(weekday) {
            weekdays.append(weekday)
        }
    }

    mutating func removeWeekday(_ weekday: Weekday) {
        if let index = weekdays.firstIndex(of: weekday) {
            weekdays.remove(at: index)
        }
    }
    
    func contains(_ weekday: Weekday) -> Bool {
        return weekdays.contains(weekday)
    }
}

enum Weekday: Int {
    case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday
}
