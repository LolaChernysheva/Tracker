//
//  CreateTrackerRouter.swift
//  Tracker
//
//  Created by Lolita Chernysheva on 03.03.2024.
//  
//

import UIKit

protocol CreateTrackerRouterProtocol: AnyObject {
    func showCreateActivityController(state:CreateActivityState, selectedDate: Date, onSave: @escaping (Tracker) -> Void)
}

final class CreateTrackerRouter: CreateTrackerRouterProtocol {
    
    private weak var view: CreateTrackerViewProtocol?
    
    init(view: CreateTrackerViewProtocol) {
        self.view = view
    }
    
    func showCreateActivityController(state:CreateActivityState, selectedDate: Date, onSave: @escaping (Tracker) -> Void) {
        guard let view = view as? UIViewController else { return }
        let createHabitController = Assembler.buildCreateActivityModule(state: state, selectedDate: selectedDate, onSave: onSave)
        let nc = UINavigationController(rootViewController: createHabitController)
        view.present(nc, animated: true)
    }
}
