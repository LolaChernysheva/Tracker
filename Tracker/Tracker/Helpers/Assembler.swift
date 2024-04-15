//
//  Assembler.swift
//  Tracker
//
//  Created by Lolita Chernysheva on 09.02.2024.
//  
//

import UIKit

protocol AssemblerProtocol: AnyObject {
    static func mainScreenBuilder() -> UIViewController
    static func buildCreateTrackerModule(selectedDate: Date, onSave: @escaping (Tracker) -> Void) -> UIViewController
    static func buildCreateActivityModule(state: CreateActivityState, selectedDate: Date, onSave: @escaping (Tracker) -> Void) -> UIViewController 
    static func buildCategoriesModule(state: CategoryScreenState, categories: [TrackerCategory], categoryIsChosen: @escaping (TrackerCategory) -> Void) -> UIViewController
    static func buildFiltersController(onSelectFilter: @escaping (Filter) -> Void) -> UIViewController
}

final class Assembler: AssemblerProtocol {

    static func mainScreenBuilder() -> UIViewController {
        let tabbarController = UITabBarController()
        
        let trackersViewController = trackersModuleBuilder()
        trackersViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Трекеры", comment: ""),
            image: UIImage(systemName: "circle.circle"),
            selectedImage: UIImage(systemName: "circle.circle.fill")
        )
        let trackersNavigationController = UINavigationController(rootViewController: trackersViewController)
        let statisticController = statisticModuleBuilder()
        
        statisticController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Статистика", comment: ""),
            image: UIImage(systemName: "hare"),
            selectedImage: UIImage(systemName: "hare.fill"))
        
        tabbarController.tabBar.tintColor = Assets.Colors.launchBlue
        tabbarController.viewControllers = [trackersNavigationController, statisticController]
        return tabbarController
    }
    
    static func buildCreateTrackerModule(selectedDate: Date, onSave: @escaping (Tracker) -> Void) -> UIViewController {
        let createTrackerViewController = CreateTrackerViewController()
        let router = CreateTrackerRouter(view: createTrackerViewController)
        let createTrackerPresenter = CreateTrackerPresenter(view: createTrackerViewController, selectedDate: selectedDate, router: router, onSave: onSave)
        createTrackerViewController.presenter = createTrackerPresenter
        return createTrackerViewController
    }
    
    static func buildEditTrackerModule(tracker: Tracker, daysCount: Int) -> UIViewController {
        let editTrackerViewController = EditTrackerViewController()
        let router = EditTrackerRouter(view: editTrackerViewController)
        let editTrackerPresenter = EditTrackerPresenter(view: editTrackerViewController, tracker: tracker, daysCount: daysCount, router: router)
        editTrackerViewController.presenter = editTrackerPresenter
        return editTrackerViewController
    }
    
    static func buildScheduleModule(selectedDays: Set<Weekday>, onSave: @escaping (Schedule) -> Void) -> UIViewController {
        let vc = ScheduleViewController()
        let presenter = SchedulePresenter(view: vc, selectedDays: selectedDays, onSave: onSave)
        vc.presenter = presenter
        return vc
    }
    
    static func buildCreateActivityModule(state: CreateActivityState, selectedDate: Date, onSave: @escaping (Tracker) -> Void) -> UIViewController {
        let createActivityViewController = CreateActivityViewController()
        let router = CreateActivityRouter(view: createActivityViewController)
        let createActivityPresenter = CreateActivityPresenter(
            view: createActivityViewController,
            selectedDate: selectedDate,
            state: state, router: router, onSave: onSave)
        createActivityViewController.presenter = createActivityPresenter
        return createActivityViewController
    }
    
    static private func trackersModuleBuilder() -> UIViewController {
        let view = TrackersViewController()
        let router = TrackersRouter(view: view)
        let presenter = TrackersPresenter(view: view, router: router)
        view.presenter = presenter
        return view
    }
    
    static private func statisticModuleBuilder() -> UIViewController {
        let view = StatisticViewController()
        let presenter = StatisticPresenter(view: view)
        view.presenter = presenter
        return view
    }
    
    static func buildCategoriesModule(state: CategoryScreenState, categories: [TrackerCategory], categoryIsChosen: @escaping (TrackerCategory) -> Void) -> UIViewController {
        let view = CategoryViewController()
        let router = CategoryRouter(view: view)
        let viewModel = CategoryViewModel(state: state, categories: categories, router: router, categoryIsChosen: categoryIsChosen)
        view.viewModel = viewModel
        return view
    }
    
    static func buildCreateCategoryModule(onSave: @escaping (TrackerCategory) -> Void) -> UIViewController {
        let view = CreateCategoryViewController()
        let presenter = CreateCategoryPresenter(view: view, onSave: onSave)
        view.presenter = presenter
        return view
        
    }
    
    static func buildFiltersController(onSelectFilter: @escaping (Filter) -> Void) -> UIViewController {
        let filtersViewController = FiltersViewController()
        let presenter = FiltersPresenter(view: filtersViewController, onSelectFilter: onSelectFilter)
        filtersViewController.presenter = presenter
        return filtersViewController
    }
}
