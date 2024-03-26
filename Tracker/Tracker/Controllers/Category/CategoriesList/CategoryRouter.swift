//
//  CategoryRouter.swift
//  Tracker
//
//  Created by Lolita Chernysheva on 26.03.2024.
//  
//

import UIKit

protocol CategoryRouterProtocol: AnyObject {
    func showCreateCategoryController(onSave: @escaping (TrackerCategory) -> Void)
}

final class CategoryRouter: CategoryRouterProtocol {
    private weak var view: CategoryViewProtocol?
    
    init(view: CategoryViewProtocol) {
        self.view = view
    }
    
    func showCreateCategoryController(onSave: @escaping (TrackerCategory) -> Void) {
        let createCategoryController = Assembler.buildCreateCategoryModule()
        guard let view = view as? UIViewController else { return }
        view.navigationController?.pushViewController(createCategoryController, animated: true)
    }
}
