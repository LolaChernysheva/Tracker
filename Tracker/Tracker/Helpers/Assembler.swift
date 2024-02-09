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
}

final class Assembler: AssemblerProtocol {
    
    static func mainScreenBuilder() -> UIViewController {
        let tabbarController = UITabBarController()
        
        let servicesController = servicesModuleBuilder()
        servicesController.tabBarItem = UITabBarItem(title: "Трекеры", image: UIImage(systemName: "circle.circle"), selectedImage: UIImage(systemName: "circle.circle.fill"))
    
        let statisticController = statisticModuleBuilder()
        
        statisticController.tabBarItem = UITabBarItem(title: "Статистика", image: UIImage(systemName: "hare"), selectedImage: UIImage(systemName: "hare.fill"))
        
        tabbarController.tabBar.tintColor = Assets.Colors.launchBlue
        tabbarController.viewControllers = [servicesController, statisticController]
        return tabbarController
    }
    
    static private func servicesModuleBuilder() -> UIViewController {
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
