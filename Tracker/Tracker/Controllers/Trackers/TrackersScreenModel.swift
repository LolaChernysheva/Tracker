//
//  TrackersScreenModel.swift
//  Tracker
//
//  Created by Lolita Chernysheva on 09.02.2024.
//  
//

import Foundation

struct TrackersScreenModel {
    enum Section {
        case headeredSection(header: String, cells: [Cell])
    }
    
    enum Cell {
        
    }
    
    let title: String
    let sections: [Section]
    let filtersButtonTitle: String
    let date: Date?
    
    static let empty: TrackersScreenModel = .init(
        title: "",
        sections: [],
        filtersButtonTitle: "",
        date: nil
    )
}
