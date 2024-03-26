//
//  TrackerCategory.swift
//  Tracker
//
//  Created by Lolita Chernysheva on 10.02.2024.
//  
//

import Foundation

struct TrackerCategory {
    let id: UUID
    let title: String
    var trackers: [Tracker] = []
}

extension TrackerCategory {
    init?(from categoryCoreData: TrackerCategoryCoreData) {
        guard let title = categoryCoreData.name,
              let id = categoryCoreData.id
        else { return nil }
        self.title = title
        self.id = id
    }
}
