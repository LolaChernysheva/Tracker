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
}
