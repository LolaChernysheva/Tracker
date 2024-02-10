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
    
    init(view: TrackersViewProtocol) {
        self.view = view
    }
    
    private func buildScreenModel() -> TrackersScreenModel {
        TrackersScreenModel (
            title: "Трекеры",
            sections: [],
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
