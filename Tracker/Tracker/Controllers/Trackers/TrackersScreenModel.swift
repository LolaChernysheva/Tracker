//
//  TrackersScreenModel.swift
//  Tracker
//
//  Created by Lolita Chernysheva on 09.02.2024.
//  
//

import UIKit

struct TrackersScreenModel {
    struct CollectionData {
        enum Section {
            case headeredSection(header: String, cells: [Cell])
            
            var cells: [Cell] {
                switch self {
                case .headeredSection(_, cells: let cells):
                    return cells
                }
            }
        }
        
        enum Cell {
            case trackerCell(TrackerCollectionViewCellViewModel)
        }
        
        let sections: [Section]
    }
    
    let title: String
    let collectionData: CollectionData
    let filtersButtonTitle: String
    let date: Date?
    let addBarButtonColor: UIColor
    
    static let empty: TrackersScreenModel = .init(
        title: "",
        collectionData: .init(sections: []),
        filtersButtonTitle: "",
        date: nil,
        addBarButtonColor: .clear
    )
}
