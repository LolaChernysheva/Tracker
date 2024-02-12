//
//  TrackersScreenModel.swift
//  Tracker
//
//  Created by Lolita Chernysheva on 09.02.2024.
//  
//

import UIKit

struct TrackersScreenModel {
    enum Section {
        case headeredSection(header: String, cells: [Cell])
    }
    
    enum Cell {
        case trackerCell(viewModel: TrackerCollectionViewCellViewModel)
    }
    
    let title: String
    let sections: [Section]
    let filtersButtonTitle: String
    let date: Date?
    let addBarButtonColor: UIColor
    
    static let empty: TrackersScreenModel = .init(
        title: "",
        sections: [],
        filtersButtonTitle: "",
        date: nil,
        addBarButtonColor: .clear
    )
}
