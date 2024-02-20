//
//  CreateActivityScreenModel.swift
//  Tracker
//
//  Created by Lolita Chernysheva on 19.02.2024.
//  
//

import UIKit

struct CreateActivityScreenModel {
    struct TableData {
        enum Section {
            case simple(cells: [Cell])
            
            var cells: [Cell] {
                switch self {
                case let .simple(cells):
                    return cells
                }
            }
        }
        
        enum Cell {
            case textFieldCell(TextFieldCellViewModel)
            case detailCell(SubtitledDetailTableViewCellViewModel)
        }
        
        let sections: [Section]
    }
    
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
            case emogi(EmogiCellViewModel)
            case color(ColorCellViewModel)
        }
        
        let sections: [Section]
    }
    
    let title: String
    let tableData: TableData
    let collectionData: CollectionData
    let cancelButtonTitle: String
    let createButtonTitle: String
    
    static let empty: CreateActivityScreenModel = .init(
        title: "",
        tableData: .init(sections: []),
        collectionData: .init(sections: []),
        cancelButtonTitle: "",
        createButtonTitle: ""
    )
}
