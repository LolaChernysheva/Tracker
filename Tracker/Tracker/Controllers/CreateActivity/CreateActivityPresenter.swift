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
    typealias CollectionData = CreateActivityScreenModel.CollectionData
    
    weak var view: CreateActivityViewProtocol?
    
    private let colors: [UIColor] = [
        .tartOrange, .carrot, .azure, .violette,
        .ufoGreen, .orchid, .palePink, .brilliantAzure,
        .eucalyptus, .cosmicCobalt, .tomato, .paleMagentaPink,
        .macaroniAndCheese, .cornflowerBlue, .blueViolet,
        .mediumOrchid, .mediumPurple, .herbalGreen
    ]
    
    private let emogis: [String] = [
        "🙂", "😻", "🌺",
        "🐶", "❤️", "😱",
        "😇", "😡", "🥶",
        "🤔", "🙌", "🍔",
        "🥦", "🏓", "🥇",
        "🎸", "🏝", "😪"
    ]
    
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
        
        let tableData = TableData(sections: [
            .simple(cells: [
                .textFieldCell(.init(
                    placeholderText: "Введите название трекера",
                    inputText: enteredActivityName,
                    textDidChanged: { [ weak self ] inputText in
                        guard let self else { return }
                        self.enteredActivityName = inputText
                    }))
            ]),
            .simple(cells: [
                .detailCell(.init(
                    title: "Категория",
                    subtitle: "")), //MARK: - TODO
                .detailCell(.init(
                    title: "Расписание",
                    subtitle: "")) //MARK: - TODO
            ])
        ])
        
        let colorCells: [CollectionData.Cell] = colors.map {
            .color(.init(color: $0))
        }
        
        let emogiCells: [CollectionData.Cell] = emogis.map {
            .emogi(.init(emogi: $0))
        }
        
        let collectionData = CollectionData.init(sections: [
            .headeredSection(header: "Emoji", cells: emogiCells),
            .headeredSection(header: "Цвет", cells: colorCells)
        ])
        return CreateActivityScreenModel(
            title: title,
            tableData: tableData,
            collectionData: collectionData,
            cancelButtonTitle: "Отменить",
            createButtonTitle: "Создать")
    }
    
    private func render() {
        view?.displayData(screenModel: buildScreenModel(), reloadTableData: true, reloadCollectionData: true)
    }
    
}

extension CreateActivityPresenter: CreateActivityPresenterProtocol {
    func setup() {
       render()
    }
}
