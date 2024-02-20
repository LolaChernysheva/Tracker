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
    static func buildCreateTrackerModule() -> UIViewController
    static func buildCreateActivityModule(state: CreateActivityState) -> UIViewController 
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
    
    static func buildCreateTrackerModule() -> UIViewController {
        let createTrackerViewController = CreateTrackerViewController()
        let createTrackerPresenter = CreateTrackerPresenter(view: createTrackerViewController)
        createTrackerViewController.presenter = createTrackerPresenter
        return createTrackerViewController
    }
    
    static func buildCreateActivityModule(state: CreateActivityState) -> UIViewController {
        let createActivityViewController = CreateActivityViewController()
        let createActivityPresenter = CreateActivityPresenter(view: createActivityViewController, state: state)
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