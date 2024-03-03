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
    
    weak var view: CreateTrackerViewProtocol?
    
    init(view: CreateTrackerViewProtocol) {
        self.view = view
    }
    
    func showCreateActivityController(state:CreateActivityState, selectedDate: Date, onSave: @escaping (Tracker) -> Void) {
        guard let view = view as? UIViewController else { return }
        let createHabitController = Assembler.buildCreateActivityModule(state: state, selectedDate: selectedDate, onSave: onSave)
        view.navigationController?.pushViewController(createHabitController, animated: true)
        //view?.showCreateActivityController(viewController: createHabitController)
    }
}
