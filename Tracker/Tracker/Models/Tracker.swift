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
    var weekdays: Set<Weekday>
    
    mutating func addWeekday(_ weekday: Weekday) {
        weekdays.insert(weekday)
    }

    mutating func removeWeekday(_ weekday: Weekday) {
        weekdays.remove(weekday)
    }
    
    func contains(_ weekday: Weekday) -> Bool {
        return weekdays.contains(weekday)
    }
}

enum Weekday: Int {
    case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday
    
    var shortName: String {
        switch self {
        case .monday: return "Пн"
        case .tuesday: return "Вт"
        case .wednesday: return "Ср"
        case .thursday: return "Чт"
        case .friday: return "Пт"
        case .saturday: return "Сб"
        case .sunday: return "Вс"
        }
    }
}
