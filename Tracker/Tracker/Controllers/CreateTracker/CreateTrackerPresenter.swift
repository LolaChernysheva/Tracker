//
//  CreateTrackerPresenter.swift
//  Tracker
//
//  Created by Lolita Chernysheva on 14.02.2024.
//  
//

import Foundation

protocol CreateTrackerPresenterProtocol: AnyObject {
    func createTracker(state: CreateActivityState)
    func setup()
}

final class CreateTrackerPresenter {

    var onSave: (Tracker) -> Void
    var selectedDate: Date
    
    private weak var view: CreateTrackerViewProtocol?
    private var router: CreateTrackerRouterProtocol
    
    init(
        view: CreateTrackerViewProtocol?,
        selectedDate: Date,
        router: CreateTrackerRouterProtocol,
        onSave: @escaping (Tracker) -> Void
    ) {
        self.view = view
        self.onSave = onSave
        self.router = router
        self.selectedDate = selectedDate
    }
    
    private func buildScreenModel() -> CreateTrackerScreenModel {
        CreateTrackerScreenModel(
            title: NSLocalizedString("Tracker creating", comment: ""),
            habitButtonTitle: NSLocalizedString("Habit", comment: ""),
            eventButtonTitle: NSLocalizedString("Irregular event", comment: ""),
            backGroundColor: .background
        )
    }
    
    private func render() {
        view?.displayData(model: buildScreenModel())
    }
}

extension CreateTrackerPresenter: CreateTrackerPresenterProtocol {
    func createTracker(state: CreateActivityState) {
        router.showCreateActivityController(state: state, selectedDate: selectedDate, onSave: onSave)
    }
    
    func setup() {
        render()
    }
}
