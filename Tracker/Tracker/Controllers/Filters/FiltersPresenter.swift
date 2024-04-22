//
//  FiltersPresenter.swift
//  Tracker
//
//  Created by Lolita Chernysheva on 11.04.2024.
//  
//

import Foundation

enum Filter {
    case allTrackers
    case completedTrackers
    case uncompletedTrackers
    case trackersForToday
    case none
}

protocol FiltersPresenterProtocol: AnyObject {
    func setup()
}

final class FiltersPresenter {
    
    weak var view: FiltersViewProtocol?
    
    var onSelectFilter: (Filter) -> Void = {_ in }
    
    init(view: FiltersViewProtocol, onSelectFilter: @escaping (Filter) -> Void ) {
        self.view = view
        self.onSelectFilter = onSelectFilter
    }
    
    private func buildScreenModel() -> FiltersScreenModel {
        return FiltersScreenModel(
            title: NSLocalizedString("Filters", comment: ""),
            tableData: .init(sections: [
                .simple(cells: [
                    .filterCell(FilterCellViewModel(title:  NSLocalizedString("All trackers", comment: ""), filter: .allTrackers, isSelected: false, selectFilter: { [ weak self ] filter in
                        guard let self = self else { return }
                        self.onSelectFilter(filter)
                    })),
                    .filterCell(FilterCellViewModel(title:  NSLocalizedString("Trackers for today", comment: ""), filter: .trackersForToday, isSelected: false, selectFilter: { [ weak self ] filter in
                        guard let self = self else { return }
                        self.onSelectFilter(filter)
                    })),
                    .filterCell(FilterCellViewModel(title:  NSLocalizedString("Completed", comment: ""), filter: .completedTrackers, isSelected: false, selectFilter: { [ weak self ] filter in
                        guard let self = self else { return }
                        self.onSelectFilter(filter)
                    })),
                    .filterCell(FilterCellViewModel(title: NSLocalizedString("Uncompleted", comment: ""), filter: .uncompletedTrackers, isSelected: false, selectFilter: { [ weak self ] filter in
                        guard let self = self else { return }
                        self.onSelectFilter(filter)
                    }))
                ])
            ])
        )
    }
    
    private func render() {
        view?.displayData(model: buildScreenModel(), reloadData: true)
    }
}

extension FiltersPresenter: FiltersPresenterProtocol {
    
    func setup() {
         render()
    }
}
