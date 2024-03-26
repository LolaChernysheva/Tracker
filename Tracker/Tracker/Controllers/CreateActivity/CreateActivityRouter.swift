//
//  CreateActivityRouter.swift
//  Tracker
//
//  Created by Lolita Chernysheva on 03.03.2024.
//  
//

import UIKit

protocol CreateActivityRouterProtocol: AnyObject {
    func showSchedule(selectedDays: Set<Weekday>, onSave: @escaping (Schedule) -> Void)
    func showCategories(state: CategoryScreenState, categories: [TrackerCategory])
}

final class CreateActivityRouter: CreateActivityRouterProtocol {
    
    private weak var view: CreateActivityViewProtocol?
    
    init(view: CreateActivityViewProtocol) {
        self.view = view
    }
    
    func showSchedule(selectedDays: Set<Weekday>, onSave: @escaping (Schedule) -> Void) {
        guard let view = view as? UIViewController else { return }
        let vc = Assembler.buildScheduleModule(selectedDays: selectedDays, onSave: onSave)
        view.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showCategories(state: CategoryScreenState, categories: [TrackerCategory]) {
        guard let view = view as? UIViewController else { return }
        let vc = Assembler.buildCategoriesModule(state: state, categories: categories)
        view.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showCreateCategory() {
        
    }
}
