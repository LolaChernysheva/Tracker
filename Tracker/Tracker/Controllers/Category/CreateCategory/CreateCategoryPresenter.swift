//
//  CreateCategoryPresenter.swift
//  Tracker
//
//  Created by Lolita Chernysheva on 26.03.2024.
//  
//

import Foundation

protocol CreateCategoryPresenterProtocol: AnyObject {
    func saveCategory()
    func setup()
}

final class CreateCategoryPresenter: CreateCategoryPresenterProtocol {
    
    weak var view: CreateCategoryViewProtocol?
    
    //var onSave: (TrackerCategory) -> Void
    
    private var enteredCategoryName: String = ""
    
    init(view: CreateCategoryViewProtocol) {
        self.view = view
    }
    
    func setup() {
        render()
    }
    
    func saveCategory() {
        
    }
    
    private func buildScreenModel() -> CreateCategoryScreenModel {
        return CreateCategoryScreenModel(
            title: "Новая категория",
            tableData: CreateCategoryScreenModel.TableData(sections: [
                .simple(cells: [
                    .textFieldCell(TextFieldCellViewModel(
                        placeholderText: "Введите название категории",
                        inputText: enteredCategoryName,
                        textDidChanged: { [ weak self ] categoryName in
                            guard let self else { return }
                            self.enteredCategoryName = categoryName
                        }))
                ])
            ]),
            doneButtonTitle: "Готово")
    }
    
    private func render() {
        view?.displayData(model: buildScreenModel(), reloadData: true)
    }
}
