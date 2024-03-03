//
//  StatisticPresenter.swift
//  Tracker
//
//  Created by Lolita Chernysheva on 09.02.2024.
//  
//

import Foundation

protocol StatisticPresenterProtocol: AnyObject {
    
}

final class StatisticPresenter {
    
    private weak var view: StatisticViewProtocol?
    
    init(view: StatisticViewProtocol) {
        self.view = view
    }
}

extension StatisticPresenter: StatisticPresenterProtocol {
    
}
