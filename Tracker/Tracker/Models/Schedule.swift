//
//  Schedule.swift
//  Tracker
//
//  Created by Lolita Chernysheva on 24.03.2024.
//  
//

import Foundation

@objc(Schedule)
public class Schedule: NSObject, NSSecureCoding {
    public static var supportsSecureCoding: Bool = true

    var weekdays: Set<Weekday>
    var date: Date?

    init(weekdays: Set<Weekday>, date: Date? = nil) {
        self.weekdays = weekdays
        self.date = date
    }

    required public init?(coder: NSCoder) {
        self.weekdays = coder.decodeObject(forKey: "weekdays") as? Set<Weekday> ?? []
        self.date = coder.decodeObject(forKey: "date") as? Date
    }

    public func encode(with coder: NSCoder) {
        coder.encode(weekdays, forKey: "weekdays")
        coder.encode(date, forKey: "date")
    }
    
    func addWeekday(_ weekday: Weekday) {
        weekdays.insert(weekday)
    }

    func removeWeekday(_ weekday: Weekday) {
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
