//
//  TrackerStore.swift
//  Tracker
//
//  Created by Lolita Chernysheva on 07.03.2024.
//  
//

import Foundation
import CoreData

enum TrackerError: Error {
    case fetchError(NSError)
    case dataConversionError
}

final class TrackerStore {
    private let context = CoreDataStack.shared.persistentContainer.viewContext

    func createTracker(with tracker: Tracker) throws {
        let trackerEntity = TrackerCoreData(context: context)
        trackerEntity.id = tracker.id
        //TODO: -
        //trackerEntity.category = tracker.category
        trackerEntity.color = tracker.color
        trackerEntity.emoji = tracker.emogi
        trackerEntity.schedule = tracker.schedule
        trackerEntity.title = tracker.title
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            throw error
        }
    }
    
    func fetchTrackers() -> [Tracker] {
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        
        do {
            let trackerEntities = try context.fetch(fetchRequest)
            let trackers = try trackerEntities.compactMap { trackerEntity -> Tracker in
                guard let tracker = Tracker(from: trackerEntity) else {
                    throw TrackerError.dataConversionError
                }
                return tracker
            }
            return trackers
        } catch let error as NSError {
            return []
        }
    }
}
