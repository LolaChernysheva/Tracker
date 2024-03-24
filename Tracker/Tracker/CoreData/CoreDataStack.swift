//
//  CoreDataStack.swift
//  Tracker
//
//  Created by Lolita Chernysheva on 07.03.2024.
//  
//

import Foundation
import CoreData

protocol CoreDataStackProtocol: AnyObject {
    var context: NSManagedObjectContext { get }
    func saveContext()
}

final class CoreDataStack: CoreDataStackProtocol {
    
    static let shared = CoreDataStack()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TrackersDBModel")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Не удалось загрузить хранилища: \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    private init() {
        registerValueTransformers()
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Не удалось сохранить контекст \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func createTracker(tracker: Tracker) {
        
    }
    
    func read() {
        
    }
    
    func update() {
        
    }
    
    func delete() {
        
    }
    
    private func registerValueTransformers() {
        ValueTransformer.setValueTransformer(UIColorTransformer(), forName: NSValueTransformerName("UIColorTransformer"))
        ValueTransformer.setValueTransformer(ScheduleTransformer(), forName: NSValueTransformerName("ScheduleTransformer"))
    }
}
