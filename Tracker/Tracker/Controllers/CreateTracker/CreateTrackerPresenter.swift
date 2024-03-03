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
    var selectedDate: Date
    
    init(view: CreateTrackerViewProtocol?, selectedDate: Date, onSave: @escaping (Tracker) -> Void) {
        self.view = view
        self.onSave = onSave
        self.selectedDate = selectedDate
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
        let createHabitController = Assembler.buildCreateActivityModule(state: .createHabit, selectedDate: selectedDate, onSave: onSave)
        view?.showCreateActivityController(viewController: createHabitController)
    }
    
    func createEvent() {
        let createEventController = Assembler.buildCreateActivityModule(state: .createEvent, selectedDate: selectedDate, onSave: onSave)
        view?.showCreateActivityController(viewController: createEventController)
    }
    
    func setup() {
        render()
    }
}
