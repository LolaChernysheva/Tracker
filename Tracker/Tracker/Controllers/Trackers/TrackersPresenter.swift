//
//  TrackersPresenter.swift
//  Tracker
//
//  Created by Lolita Chernysheva on 09.02.2024.
//  
//

import Foundation
import UIKit

protocol TrackersPresenterProtocol: AnyObject {
    func setup()
    func addTracker()
    func showSearchResults(with inputText: String)
}

final class TrackersPresenter {
    
    weak var view: TrackersViewProtocol?
    
    var categories: [TrackerCategory] = [
        .init(title: "Домашний уют", trackers: [
            .init(id: UUID(), title: "Поливать растения", color: .herbalGreen, emogi: "❤️", schedule: .init())
        ]),
        .init(title: "Радостные мелочи", trackers: [
            .init(id: UUID(), title: "Кошка заслонила камеру на созвоне", color: .tartOrange, emogi: "😻", schedule: .init()),
            .init(id: UUID(), title: "Бабушка прислала открытку в вотсапе", color: .carrot, emogi: "🌺", schedule: .init()),
            .init(id: UUID(), title: "Свидания в апреле", color: .cornflowerBlue, emogi: "❤️", schedule: .init())
        ])
    ]
    
    var presentBackground: Bool = false
    
    private var completedTrackers: [TrackerRecord] = []
    private var filteredCategories = [TrackerCategory]()
    
    init(view: TrackersViewProtocol) {
        self.view = view
    }
    
    private func buildScreenModel() -> TrackersScreenModel {
        var categories = [TrackerCategory]()
        if let view,
           view.isFiltering {
            categories = filteredCategories
        } else {
            categories = self.categories
        }
        let sections: [TrackersScreenModel.CollectionData.Section] = categories.map { category in
            let cells: [TrackersScreenModel.CollectionData.Cell] = category.trackers.map { tracker in
                return .trackerCell(TrackerCollectionViewCellViewModel(
                    emoji: tracker.emogi,
                    title: tracker.title,
                    isPinned: false, //MARK: - TODO
                    daysCount: 5, //MARK: -TODO
                    color: tracker.color,
                    doneButtonHandler: {
                        //MARK: - TODO
                    }))
            }
            return .headeredSection(header: category.title, cells: cells)
        }
        
        return TrackersScreenModel (
            title: "Трекеры", 
            emptyState: backgroundState(),
            collectionData: .init(sections: sections),
            filtersButtonTitle: "Фильтры",
            date: Date(), //MARK: - TODO
            addBarButtonColor: Assets.Colors.navBarItem ?? .black
        )
    }
    
    private func backgroundState() -> BackgroundView.BackgroundState {
        if categories.isEmpty {
            return .trackersDoNotExist
        } else {
            return .empty
        }
    }
    private func render(reloadData: Bool = true) {
        view?.displayData(model: buildScreenModel(), reloadData: reloadData)
    }
}

extension TrackersPresenter: TrackersPresenterProtocol {
    func setup() {
        render()
    }
    
    func addTracker() {
        let createTrackerController = Assembler.buildCreateTrackerModule()
        view?.showCreateController(viewController: createTrackerController)
    }
    
    func showSearchResults(with inputText: String) {
        self.filteredCategories = categories.map { category in
            let filtredTrackers = category.trackers.filter { $0.title.localizedCaseInsensitiveContains(inputText) }
            return TrackerCategory(title: category.title, trackers: filtredTrackers)
        }
        render(reloadData: true)
    }
}
