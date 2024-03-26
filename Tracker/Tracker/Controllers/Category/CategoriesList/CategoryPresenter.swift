//
//  CategoryPresenter.swift
//  Tracker
//
//  Created by Lolita Chernysheva on 24.03.2024.
//  
//

import Foundation

enum CategoryScreenState {
    case empty
    case categoriesList
}

protocol CategoryPresenterProtocol: AnyObject {
    var shouldShowBackgroundView: Bool { get }
    var state: CategoryScreenState? { get }
    func setup()
    func addCategory()
}

final class CategoryPresenter {
    
    weak var view: CategoryViewProtocol?
    var state: CategoryScreenState?
    private var categories: [TrackerCategory]
    private var categoryStore = TrackerCategoryStore()

    var shouldShowBackgroundView: Bool {
        get {
            state == .empty
        }
    }
    
    init(view: CategoryViewProtocol, state: CategoryScreenState, categories: [TrackerCategory]) {
        self.view = view
        self.state = state
        self.categories = categories
    }
    
    private func buildScreenModel() -> CategoryScreenModel {
        return CategoryScreenModel(
            title: "Категория",
            tableData: buildTableData(),
            buttonTitle: "Добавить категорию"
        )
    }
    
    private func buildTableData() -> CategoryScreenModel.TableData {
        return CategoryScreenModel.TableData(sections: [
            buildCategoriesSection()
        ])
    }
    
    private func buildCategoriesSection() -> CategoryScreenModel.TableData.Section {
        .simpleSection( cells:categories.map { .labledCell(LabledCellViewModel(title: $0.title))})
    }

    
    private func render() {
        view?.displayData(model: buildScreenModel(), reloadData: true)
    }
}

extension CategoryPresenter: CategoryPresenterProtocol {
    func setup() {
        render()
    }
    
    func addCategory() {
       // router?.showCreateCategoryController(categories: categories)
    }
    
//    func saveCategory() {
//        let category: TrackerCategory = TrackerCategory(id: UUID(), title: enteredCategoryName)
//        onSave(category)
//        do {
//            try categoryStore.createCategory(with: category)
//        } catch {
//            print("❌❌❌ Не удалось преобразовать TrackerCategory в TrackerCategoryCoreData")
//        }
//    }
}

