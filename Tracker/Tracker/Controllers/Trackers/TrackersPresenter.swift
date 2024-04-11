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
        get {
            let trackerStore = TrackerStore()
            return trackerStore.fetchTrackers()
        }

        set(newTrackers) {
            for tracker in newTrackers {
                guard let category = tracker.category else { continue }
                trackersByCategory[category, default: []].append(tracker)
            }
        }
    }
    
    var trackersByCategory = [TrackerCategory: [Tracker]]()
    
    var shouldShowBackgroundView: Bool {
        guard let view = view else { return false }
        return ((view.isSearching || view.isFiltering) && filteredTrackersByCategory.isEmpty) || trackers.isEmpty
    }
    
    private var completedTrackers: Set<TrackerRecord> {
        get {
            let trackerRecordsStore = TrackerRecordStore()
            var trackersRecords = trackerRecordsStore.fetchTrackerRecords()
            return Set(trackersRecords)
        }
        
        set {}
    }
    
    private weak var view: TrackersViewProtocol?
    private let router: TrackersRouterProtocol
    private var filteredTrackersByCategory = [TrackerCategory: [Tracker]]()
    
    init(
        view: TrackersViewProtocol,
        router: TrackersRouterProtocol
    ) {
        self.view = view
        self.router = router
    }
    
    private func buildScreenModel() -> TrackersScreenModel {
        let categoriesWithTrackers = (view?.isFiltering == true || view?.isSearching == true) ? filteredTrackersByCategory : trackersByCategory
        let categories = Array(categoriesWithTrackers.keys)
        let sections: [TrackersScreenModel.CollectionData.Section] = categories.compactMap { category in
            let cells = categoriesWithTrackers.values
                .flatMap { $0 }
                .filter { $0.category == category }
                .compactMap { tracker -> TrackersScreenModel.CollectionData.Cell? in
                    guard let view else { return nil }
                    let trackerRecord = TrackerRecord(id: tracker.id, date: view.currentDate)
                    let isCompleted = self.completedTrackers.contains(trackerRecord)
                    let daysCount = completedTrackers.filter({$0.id == tracker.id}).count
                    return .trackerCell(TrackerCollectionViewCellViewModel(
                        emoji: tracker.emogi,
                        title: tracker.title,
                        isPinned: tracker.isPinned,
                        daysCount: daysCount,
                        color: tracker.color,
                        doneButtonHandler: { [ weak self ] in
                            guard let self else { return }
                            if view.currentDate > Date() {
                                view.showCompleteTrackerErrorAlert()
                                return
                            } else {
                                if completedTrackers.contains(trackerRecord) {
                                    deleteTrackerRecord(withId: trackerRecord.id)
                                    completedTrackers.remove(trackerRecord)
                                } else {
                                    addTrackerRecord(trackerRecord: trackerRecord)
                                    completedTrackers.insert(trackerRecord)
                                }
                            }
                            DispatchQueue.main.async {
                                self.render(reloadData: true)
                            }
                        },
                        pinHandler: { isPinned in
                            var tracker = Tracker(id: tracker.id, title: tracker.title, color: tracker.color, emogi: tracker.emogi, schedule: tracker.schedule, category: tracker.category, isPinned: isPinned)
                            let trackerStore = TrackerStore()
                            try? trackerStore.updateTracker(with: tracker)
                            if let category = tracker.category, var trackersInCategory = self.trackersByCategory[category] {
                                if let index = trackersInCategory.firstIndex(where: { $0.id == tracker.id }) {
                                    trackersInCategory[index] = tracker
                                    self.trackersByCategory[category] = trackersInCategory
                                    DispatchQueue.main.async {
                                        self.render(reloadData: true)
                                    }
                                }
                            }
                        },
                        isCompleted: isCompleted,
                        deleteTrackerHandler: { [ weak self ] in
                            guard let self else { return }
                            self.deleteTracker(withId: tracker.id)
                            if let category = tracker.category, var trackersInCategory = self.trackersByCategory[category] {
                                if let index = trackersInCategory.firstIndex(where: { $0.id == tracker.id }) {
                                    trackersInCategory.remove(at: index)
                                    self.trackersByCategory[category] = trackersInCategory
                                    DispatchQueue.main.async {
                                        self.render(reloadData: true)
                                    }
                                }
                            }
                        }, editTrackerHandler: { [ weak self ] in
                            guard let self else { return }
                            self.editTracker(tracker: tracker, daysCount: daysCount)
                        })
                    )
                }
            return .headeredSection(header: category.title, cells: cells)
        }
        
        return TrackersScreenModel (
            title: NSLocalizedString("Trackers", comment: ""),
            emptyState: backgroundState(),
            collectionData: .init(sections: sections),
            filtersButtonTitle: NSLocalizedString("Filters", comment: ""),
            addBarButtonColor: Assets.Colors.navBarItem ?? .black
        )
    }
    
    private func editTracker(tracker: Tracker, daysCount: Int) {
        router.showEditTracker(tracker: tracker, daysCount: daysCount, onSave: { [ weak self ] tracker in
            guard let self else { return }
            if let category = tracker.category, var trackersInCategory = self.trackersByCategory[category] {
                if let index = trackersInCategory.firstIndex(where: { $0.id == tracker.id }) {
                    trackersInCategory[index] = tracker
                    self.trackersByCategory[category] = trackersInCategory
                    DispatchQueue.main.async {
                        self.render(reloadData: true)
                    }
                }
            }
        })
    }
    
    private func addTrackerRecord(trackerRecord: TrackerRecord) {
        do {
            try TrackerRecordStore().createTrackerRecord(with: trackerRecord)
            print("✅ TrackerRecord успешно добавлен")
            render(reloadData: true)
        } catch {
            print("❌ Не удалось создать TrackerRecord: \(error)")
        }
    }
    
    private func deleteTrackerRecord(withId id: UUID) {
        do {
            try TrackerRecordStore().deleteTrackerRecord(withId: id)
        } catch {
            print("Ошибка при удалении записи трекера: \(error)")
        }
    }
    
    private func deleteTracker(withId id: UUID) {
        do {
            try TrackerStore().deleteTracker(withId: id)
        } catch {
            print("Ошибка при удалении трекера: \(error)")
        }
    }
    
    private func backgroundState() -> BackgroundView.BackgroundState {
        guard let view = view else { return .empty }
        if trackers.isEmpty {
            return .trackersDoNotExist
        } else if ((view.isSearching || view.isFiltering) && filteredTrackersByCategory.isEmpty){
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
        
        let trackers = TrackerStore().fetchTrackers()
        trackers.forEach { tracker in
            if let category = tracker.category {
                self.trackersByCategory[category, default: []].append(tracker)
            }
        }
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
        self.filteredTrackersByCategory.removeAll()
        trackersByCategory.values
            .flatMap { $0 }
            .filter { $0.title.contains(inputText) }
            .forEach {
                if let category = $0.category {
                    self.filteredTrackersByCategory[category, default: []].append($0)
                }
            }
        render(reloadData: true)
    }
    
    func filterTrackers(for date: Date) {
        let weekday = Calendar.current.component(.weekday, from: date)
        
        guard let selectedWeekday = Weekday(rawValue: weekday) else { return }
        
        filteredTrackersByCategory.removeAll()
    
        trackersByCategory.forEach { category, trackers in
            let filteredTrackers = trackers.filter {
                $0.schedule.contains(selectedWeekday) || $0.schedule.date == date
            }
            if !filteredTrackers.isEmpty {
                filteredTrackersByCategory[category] = filteredTrackers
            }
        }
        
        render(reloadData: true)
    }
}
