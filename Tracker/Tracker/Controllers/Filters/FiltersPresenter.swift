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
}

protocol FiltersPresenterProtocol: AnyObject {
    func setup()
    func chooseFilter(filter: Filter)
}

final class FiltersPresenter {
    
    weak var view: FiltersViewProtocol?
    
    private var filter: Filter?
    
    init(view: FiltersViewProtocol) {
        self.view = view
    }
    
    private func buildScreenModel() -> FiltersScreenModel {
        return FiltersScreenModel(
            title: NSLocalizedString("Filters", comment: ""),
            tableData: .init(sections: [
                .simple(cells: [
                    .labled(.init(title: NSLocalizedString("All trackers", comment: ""), style: .leftSideTitle)),
                    .labled(.init(title: NSLocalizedString("Trackers for today", comment: ""), style: .leftSideTitle)),
                    .labled(.init(title: NSLocalizedString("Completed", comment: ""), style: .leftSideTitle)),
                    .labled(.init(title: NSLocalizedString("Uncompleted", comment: ""), style: .leftSideTitle))
                ])
            ])
        )
    }
    
    private func render() {
        view?.displayData(model: buildScreenModel(), reloadData: true)
    }
}

extension FiltersPresenter: FiltersPresenterProtocol {
    func chooseFilter(filter: Filter) {
        
    }
    
    func setup() {
         render()
    }
}
