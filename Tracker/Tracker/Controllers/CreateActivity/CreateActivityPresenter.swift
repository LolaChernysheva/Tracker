//
//  CreateActivityPresenter.swift
//  Tracker
//
//  Created by Lolita Chernysheva on 19.02.2024.
//  
//

import UIKit

enum CreateActivityState {
    case createHabit
    case createEvent
}

protocol CreateActivityPresenterProtocol: AnyObject {
    func setup()
}

final class CreateActivityPresenter {

    typealias TableData = CreateActivityScreenModel.TableData
    
    weak var view: CreateActivityViewProtocol?
    
    private var state: CreateActivityState?
    private var enteredActivityName: String = "" //MARK: - TODO
    
    init(view: CreateActivityViewProtocol, state: CreateActivityState) {
        self.view = view
        self.state = state
    }
    
    private func buildScreenModel() -> CreateActivityScreenModel {
        let title: String = {
            switch self.state {
            case .createHabit:
                "Новая привычка"
            case .createEvent:
                "Новое нерегулярное событие"
            case nil:
                ""
            }
        }()

        let sections: [TableData.Section] = [
            createActivityNameSection(),
            createActivitySettingsSection(),
            createEmojiSection(),
            createColorSection()
        ]
        
        return CreateActivityScreenModel(
            title: title,
            tableData: .init(sections: sections),
            cancelButtonTitle: "Отменить",
            createButtonTitle: "Создать")
    }
    
    private func createEmojiSection() -> TableData.Section {
        return .headered(
            header: "Emoji",
            cells: [.emogiCell])
    }
    
    private func createColorSection() -> TableData.Section {
        return .headered(
            header: "Цвет",
            cells: [.colorCell])
    }
    
    private func createActivityNameSection() -> TableData.Section {
        return .simple(cells: [
            .textFieldCell(.init(
                placeholderText: "Введите название трекера",
                inputText: enteredActivityName,
                textDidChanged: { [ weak self ] inputText in
                    guard let self else { return }
                    self.enteredActivityName = inputText
                }))
        ])
    }
    
    private func createActivitySettingsSection() -> TableData.Section {
        let categogyCell: TableData.Cell = .detailCell(.init(
            title: "Категория",
            subtitle: "")) //MARK: - TODO
        
        let scheduleCell: TableData.Cell = .detailCell(.init(
            title: "Расписание",
            subtitle: "")) //MARK: - TODO
        
        var activitySettingsCells: [TableData.Cell] = []
        
        activitySettingsCells.append(categogyCell)
        if state == .createHabit {
            activitySettingsCells.append(scheduleCell)
        }
        
        return.simple(cells: activitySettingsCells)
    }
    
    private func render() {
        view?.displayData(screenModel: buildScreenModel(), reloadTableData: true)
    }
}

extension CreateActivityPresenter: CreateActivityPresenterProtocol {
    func setup() {
       render()
    }
}
