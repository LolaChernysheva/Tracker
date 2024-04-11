//
//  EditTrackerRouter.swift
//  Tracker
//
//  Created by Lolita Chernysheva on 11.04.2024.
//  
//

import UIKit

protocol EditTrackerRouterProtocol: AnyObject {
    func showSchedule(selectedDays: Set<Weekday>, onSave: @escaping (Schedule) -> Void)
    func showCategories(state: CategoryScreenState, categories: [TrackerCategory], categoryIsChosen: @escaping (TrackerCategory) -> Void)
}

final class EditTrackerRouter: EditTrackerRouterProtocol {
    
    private weak var view: EditTrackerViewProtocol?
    
    init(view: EditTrackerViewProtocol) {
        self.view = view
    }
    
    
    func showSchedule(selectedDays: Set<Weekday>, onSave: @escaping (Schedule) -> Void) {
        guard let view = view as? UIViewController else { return }
        let vc = Assembler.buildScheduleModule(selectedDays: selectedDays, onSave: onSave)
        view.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showCategories(state: CategoryScreenState, categories: [TrackerCategory], categoryIsChosen: @escaping (TrackerCategory) -> Void) {
        guard let view = view as? UIViewController else { return }
        let vc = Assembler.buildCategoriesModule(state: state, categories: categories, categoryIsChosen: categoryIsChosen)
        view.navigationController?.pushViewController(vc, animated: true)
    }
}