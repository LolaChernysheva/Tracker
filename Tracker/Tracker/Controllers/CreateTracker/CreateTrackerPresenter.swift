//
//  CreateTrackerPresenter.swift
//  Tracker
//
//  Created by Lolita Chernysheva on 14.02.2024.
//  
//

import Foundation

protocol CreateTrackerPresenterProtocol: AnyObject {
    func createHabit()
    func createEvent()
    func setup()
    
}

final class CreateTrackerPresenter {
    
    weak var view: CreateTrackerViewProtocol?
    var onSave: (Tracker) -> Void
    
    init(view: CreateTrackerViewProtocol?, onSave: @escaping (Tracker) -> Void) {
        self.view = view
        self.onSave = onSave
    }
    
    private func buildScreenModel() -> CreateTrackerScreenModel {
        CreateTrackerScreenModel(
            title: "Создание трекера",
            habitButtonTitle: "Привычка",
            eventButtonTitle: "Нерегулярное событие",
            backGroundColor: .background
        )
    }
    
    private func render() {
        view?.displayData(model: buildScreenModel())
    }
}

extension CreateTrackerPresenter: CreateTrackerPresenterProtocol {
    func createHabit() {
        let createHabitController = Assembler.buildCreateActivityModule(state: .createHabit, onSave: onSave)
        view?.showCreateActivityController(viewController: createHabitController)
    }
    
    func createEvent() {
        let createEventController = Assembler.buildCreateActivityModule(state: .createEvent, onSave: onSave)
        view?.showCreateActivityController(viewController: createEventController)
    }
    
    func setup() {
        render()
    }
}
