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
    static func buildCreateTrackerModule(onSave: @escaping (Tracker) -> Void) -> UIViewController
    static func buildCreateActivityModule(state: CreateActivityState, onSave: @escaping (Tracker) -> Void) -> UIViewController 
}

final class Assembler: AssemblerProtocol {

    static func mainScreenBuilder() -> UIViewController {
        let tabbarController = UITabBarController()
        
        let trackersViewController = trackersModuleBuilder()
        trackersViewController.tabBarItem = UITabBarItem(title: "Трекеры", image: UIImage(systemName: "circle.circle"), selectedImage: UIImage(systemName: "circle.circle.fill"))
        let trackersNavigationController = UINavigationController(rootViewController: trackersViewController)
        let statisticController = statisticModuleBuilder()
        
        statisticController.tabBarItem = UITabBarItem(title: "Статистика", image: UIImage(systemName: "hare"), selectedImage: UIImage(systemName: "hare.fill"))
        
        tabbarController.tabBar.tintColor = Assets.Colors.launchBlue
        tabbarController.viewControllers = [trackersNavigationController, statisticController]
        return tabbarController
    }
    
    static func buildCreateTrackerModule(onSave: @escaping (Tracker) -> Void) -> UIViewController {
        let createTrackerViewController = CreateTrackerViewController()
        let createTrackerPresenter = CreateTrackerPresenter(view: createTrackerViewController, onSave: onSave)
        createTrackerViewController.presenter = createTrackerPresenter
        return createTrackerViewController
    }
    
    static func buildScheduleModule(selectedDays: Set<Weekday>, onSave: @escaping (Schedule) -> Void) -> UIViewController {
        let vc = ScheduleViewController()
        let presenter = SchedulePresenter(view: vc, selectedDays: selectedDays, onSave: onSave)
        vc.presenter = presenter
        return vc
    }
    
    static func buildCreateActivityModule(state: CreateActivityState, onSave: @escaping (Tracker) -> Void) -> UIViewController {
        let createActivityViewController = CreateActivityViewController()
        let createActivityPresenter = CreateActivityPresenter(
            view: createActivityViewController,
            state: state, onSave: onSave)
        createActivityViewController.presenter = createActivityPresenter
        return createActivityViewController
    }
    
    static private func trackersModuleBuilder() -> UIViewController {
        let view = TrackersViewController()
        let presenter = TrackersPresenter(view: view)
        view.presenter = presenter
        return view
    }
    
    static private func statisticModuleBuilder() -> UIViewController {
        let view = StatisticViewController()
        let presenter = StatisticPresenter(view: view)
        view.presenter = presenter
        return view
    }
}
