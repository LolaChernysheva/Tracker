//
//  ScheduleTransformer.swift
//  Tracker
//
//  Created by Lolita Chernysheva on 24.03.2024.
//  
//

import Foundation

@objc(ScheduleTransformer)
final class ScheduleTransformer: NSSecureUnarchiveFromDataTransformer {

    override static var allowedTopLevelClasses: [AnyClass] {
        [Schedule.self]
    }
    
    static func register() {
        let transformer = ScheduleTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: NSValueTransformerName("ScheduleTransformer"))
    }
}
