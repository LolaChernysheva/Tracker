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
    
    init(view: CreateTrackerViewProtocol?) {
        self.view = view
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
    func createHabit() {}
    
    func createEvent() {}
    
    func setup() {
        render()
    }
}
