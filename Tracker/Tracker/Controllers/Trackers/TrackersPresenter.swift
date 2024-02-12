//
//  TrackersPresenter.swift
//  Tracker
//
//  Created by Lolita Chernysheva on 09.02.2024.
//  
//

import Foundation

protocol TrackersPresenterProtocol: AnyObject {
    func setup()
    func addTracker()
    func shouldShowBackground() -> Bool
}

final class TrackersPresenter {
    
    weak var view: TrackersViewProtocol?
    
    private var categories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    
    init(view: TrackersViewProtocol) {
        self.view = view
    }
    
    private func buildScreenModel() -> TrackersScreenModel {
        let sections: [TrackersScreenModel.CollectionData.Section] = categories.map { category in
            let cells: [TrackersScreenModel.CollectionData.Cell] = category.trackers.map { tracker in
                return .trackerCell(TrackerCollectionViewCellViewModel.init(
                    emoji: tracker.emigi,
                    title: tracker.title,
                    isPinned: false, //MARK: - TODO
                    daysCount: 5, //MARK: -TODO
                    doneButtonHandler: {
                        //MARK: - TODO
                    }))
            }
            return .headeredSection(header: category.title, cells: cells)
        }
        
        return TrackersScreenModel (
            title: "Трекеры",
            collectionData: .init(sections: sections),
            filtersButtonTitle: "Фильтры",
            date: Date(), //MARK: - TODO
            addBarButtonColor: Assets.Colors.navBarItem ?? .black
        )
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
        
    }
    
    func shouldShowBackground() -> Bool {
        //MARK: - TODO
        return true
    }
}
