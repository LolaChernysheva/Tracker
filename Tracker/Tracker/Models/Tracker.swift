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

extension Tracker {
    init?(from trackerEntity: TrackerCoreData) {
        guard let id = trackerEntity.id,
              let title = trackerEntity.title,
              let color = trackerEntity.color,
              let emoji = trackerEntity.emoji,
              let schedule = trackerEntity.schedule
        else { return nil }
        self.id = id
        self.title = title
        self.color = color
        self.emogi = emoji
        self.schedule = schedule
    }
}
