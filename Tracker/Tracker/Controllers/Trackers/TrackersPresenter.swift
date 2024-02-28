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
    var shouldShowBackgroundView: Bool { get }
    func setup()
    func addTracker()
    func showSearchResults(with inputText: String)
    func filterTrackers(for date: Date)
}

final class TrackersPresenter {
    
    weak var view: TrackersViewProtocol?
    
    var categories: [TrackerCategory] = [
        .init(title: "Ыщьыоы", trackers: [
            .init(id: UUID(), title: "jhhjjhhjjhhjjhhjjhhjjhhjjhhjjhhjjhhj", color: .azure, emogi: "🥳", schedule: .init(weekdays: [.friday])),
            .init(id: UUID(), title: "jhhj", color: .azure, emogi: "🥳", schedule: .init(weekdays: [.friday])),
            .init(id: UUID(), title: "jhhj", color: .azure, emogi: "🥳", schedule: .init(weekdays: [.friday])),
        ]),
        .init(title: "Ыщьыоы", trackers: [
            .init(id: UUID(), title: "jhhj", color: .azure, emogi: "🥳", schedule: .init(weekdays: [.friday])),
            .init(id: UUID(), title: "jhhj", color: .azure, emogi: "🥳", schedule: .init(weekdays: [.friday])),
            .init(id: UUID(), title: "jhhj", color: .azure, emogi: "🥳", schedule: .init(weekdays: [.friday])),
        ])
    ]
    var shouldShowBackgroundView: Bool {
        guard let view = view else { return false }
        return ((view.isSearching || view.isFiltering) && filteredCategories.isEmpty) || categories.isEmpty
    }
    
    private var completedTrackers: Set<TrackerRecord> = []
    private var filteredCategories = [TrackerCategory]()
    
    init(view: TrackersViewProtocol) {
        self.view = view
    }
    
    private func buildScreenModel() -> TrackersScreenModel {
        var categories = [TrackerCategory]()
        if let view,
           view.isFiltering  || view.isSearching {
            categories = filteredCategories
        } else {
            categories = self.categories
        }
        
        let sections: [TrackersScreenModel.CollectionData.Section] = categories.map { category in
            let cells: [TrackersScreenModel.CollectionData.Cell] = category.trackers.compactMap { tracker in
                guard let view else { return nil }
                let trackerRecord = TrackerRecord(id: tracker.id, date: view.currentDate)
                let isCompleted = self.completedTrackers.contains(trackerRecord)
                var daysCount = completedTrackers.filter({$0.id == tracker.id}).count
                return .trackerCell(TrackerCollectionViewCellViewModel(
                    emoji: tracker.emogi,
                    title: tracker.title,
                    isPinned: false, //MARK: - TODO
                    daysCount: daysCount,
                    color: tracker.color,
                    doneButtonHandler: { [ weak self ] in
                        guard let self else { return }
                        if view.currentDate > Date() {
                            view.showCompleteTrackerErrorAlert()
                            return
                        } else {
                            if completedTrackers.contains(trackerRecord) {
                                completedTrackers.remove(trackerRecord)
                            } else {
                                completedTrackers.insert(trackerRecord)
                            }
                        }
                        DispatchQueue.main.async {
                            self.render(reloadData: true)
                        }
                    },
                    isCompleted: isCompleted)
                )
            }
            return .headeredSection(header: category.title, cells: cells)
        }
        
        return TrackersScreenModel (
            title: "Трекеры",
            emptyState: backgroundState(),
            collectionData: .init(sections: sections),
            filtersButtonTitle: "Фильтры",
            addBarButtonColor: Assets.Colors.navBarItem ?? .black
        )
    }
    
    private func backgroundState() -> BackgroundView.BackgroundState {
        guard let view = view else { return .empty }
        if categories.isEmpty {
            return .trackersDoNotExist
        } else if ((view.isSearching || view.isFiltering) && filteredCategories.isEmpty){
            return .emptySearchResult
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
        let createTrackerController = Assembler.buildCreateTrackerModule() { [ weak self ] tracker in
            guard let self else { return }
            categories.append(.init(title: "777", trackers: [tracker]))
            render(reloadData: true)
        }
        view?.showCreateController(viewController: createTrackerController)
    }
    
    func showSearchResults(with inputText: String) {
        self.filteredCategories = categories.map { category in
            let filtredTrackers = category.trackers.filter { $0.title.localizedCaseInsensitiveContains(inputText) }
            return  TrackerCategory(title: category.title, trackers: filtredTrackers)
        }
        filteredCategories.removeAll { $0.trackers.isEmpty }

        render(reloadData: true)
    }
    
    func filterTrackers(for date: Date) {
        let weekday = Calendar.current.component(.weekday, from: date)
        
        guard let selectedWeekday = Weekday(rawValue: weekday) else { return }
        
        filteredCategories = categories.compactMap {
            let filteredTrackers = $0.trackers.filter { $0.schedule.contains(selectedWeekday) }
            return filteredTrackers.isEmpty ? nil : TrackerCategory(title: $0.title, trackers: filteredTrackers)
        }
        
        render(reloadData: true)
    }
}
