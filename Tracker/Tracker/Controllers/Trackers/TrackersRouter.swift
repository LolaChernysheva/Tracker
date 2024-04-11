//
//  TrackersRouter.swift
//  Tracker
//
//  Created by Lolita Chernysheva on 03.03.2024.
//  
//

import UIKit

protocol TrackersRouterProtocol: AnyObject {
    func showCreateTrackerController(selectedDate: Date, onSave: @escaping (Tracker) -> Void)
    func showEditTracker(tracker: Tracker, daysCount: Int, onSave: @escaping (Tracker) -> Void)
    func showFiltersController()
}

final class TrackersRouter: TrackersRouterProtocol {
    
    private weak var view: TrackersViewProtocol?
    
    init(view: TrackersViewProtocol) {
        self.view = view
    }
    
    func showCreateTrackerController(selectedDate: Date, onSave: @escaping (Tracker) -> Void) {
        guard let view = view as? UIViewController else { return }
        let createTrackerController = Assembler.buildCreateTrackerModule(selectedDate: selectedDate, onSave: onSave)
        let nc = UINavigationController(rootViewController: createTrackerController)
        view.navigationController?.present(nc, animated: true)
    }
    
    func showEditTracker(tracker: Tracker, daysCount: Int, onSave: @escaping (Tracker) -> Void) {
        guard let view = view as? UIViewController else { return }
        let editTrackerController = Assembler.buildEditTrackerModule(tracker: tracker, daysCount: daysCount)
        view.navigationController?.pushViewController(editTrackerController, animated: true)
    }
    
    func showFiltersController() {
        guard let view = view as? UIViewController else { return }
        let filtersController = Assembler.buildFiltersController()
        view.navigationController?.pushViewController(filtersController, animated: true)
    }
}
