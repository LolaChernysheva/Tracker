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
    
    var trackers: [Tracker] {
        Array(trackersByCategory.values.flatMap { $0 })
    }
    //{
//        get {
//            let trackerStore = TrackerStore()
//            return trackerStore.fetchTrackers()
//        }
//
//        set(newTrackers) {
//            for tracker in newTrackers {
//                guard let category = tracker.category else { continue }
//                trackersByCategory[category, default: []].append(tracker)
//            }
//        }
 //   }
    
    var trackersByCategory = [TrackerCategory: [Tracker]]()
    
    var shouldShowBackgroundView: Bool {
        guard let view = view else { return false }
        return ((view.isSearching || view.isFiltering) && filteredCategories.isEmpty) || trackers.isEmpty
    }
    
    private weak var view: TrackersViewProtocol?
    private let router: TrackersRouterProtocol
    private var completedTrackers: Set<TrackerRecord> = []
    private var filteredCategories = [TrackerCategory]()
    
    init(view: TrackersViewProtocol, router: TrackersRouterProtocol) {
        self.view = view
        self.router = router
    }
    
    private func buildScreenModel() -> TrackersScreenModel {
        let categories = (view?.isFiltering == true || view?.isSearching == true) ? filteredCategories : Array(trackersByCategory.keys)
        
        let sections: [TrackersScreenModel.CollectionData.Section] = categories.compactMap { category in
            let cells = trackers
                .filter { $0.category == category }
                .compactMap { tracker -> TrackersScreenModel.CollectionData.Cell? in
                guard let view else { return nil }
                let trackerRecord = TrackerRecord(id: tracker.id, date: view.currentDate)
                let isCompleted = self.completedTrackers.contains(trackerRecord)
                let daysCount = completedTrackers.filter({$0.id == tracker.id}).count
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
        if trackers.isEmpty {
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
        guard let view = view else { return }
        router.showCreateTrackerController(selectedDate: view.currentDate) { [weak self] tracker in
            guard let self = self, let category = tracker.category else { return }
            self.trackersByCategory[category, default: []].append(tracker)
            self.render(reloadData: true)
        }
    }
    
    func showSearchResults(with inputText: String) {
//        self.filteredCategories = trackersByCategory.map { category, trackers in
//            let filtredTrackers = trackers.filter { $0.title.localizedCaseInsensitiveContains(inputText) }
//            return  TrackerCategory(id: UUID(), title: category.title)
//        }

        render(reloadData: true)
    }
    
    func filterTrackers(for date: Date) {
        let weekday = Calendar.current.component(.weekday, from: date)
        
        guard let selectedWeekday = Weekday(rawValue: weekday) else { return }
        
        filteredCategories = trackersByCategory.compactMap { category, trackers in
            let filteredTrackers = trackers.filter { $0.schedule.contains(selectedWeekday) || $0.schedule.date == date}
            return filteredTrackers.isEmpty ? nil : TrackerCategory(id: category.id, title: category.title)
        }
        
        render(reloadData: true)
    }
}
