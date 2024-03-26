//
//  CreateCategoryScreenModel.swift
//  Tracker
//
//  Created by Lolita Chernysheva on 26.03.2024.
//  
//

import Foundation

struct CreateCategoryScreenModel {
    
    struct TableData {
        enum Section {
            case simple(cells: [Cell])
        }
        
        enum Cell {
            case textFieldCell(TextFieldCellViewModel)
        }
        
        let sections: [Section]
    }
    
    let title: String
    let tableData: TableData
    let doneButtonTitle: String
    
    static let empty: CreateCategoryScreenModel = CreateCategoryScreenModel(title: "", tableData: .init(sections: []), doneButtonTitle: "")
    
}
