//
//  TrackersPresenter.swift
//  Tracker
//
//  Created by Lolita Chernysheva on 09.02.2024.
//  
//

import Foundation

protocol TrackersPresenterProtocol: AnyObject {
    
}

final class TrackersPresenter {
    
    weak var view: TrackersViewProtocol?
    
    init(view: TrackersViewProtocol) {
        self.view = view
    }
    
}

extension TrackersPresenter: TrackersPresenterProtocol {
    
}
