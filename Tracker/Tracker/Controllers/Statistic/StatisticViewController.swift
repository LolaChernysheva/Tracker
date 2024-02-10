//
//  StatisticViewController.swift
//  Tracker
//
//  Created by Lolita Chernysheva on 09.02.2024.
//  
//

import UIKit

protocol StatisticViewProtocol: AnyObject {
    
}

final class StatisticViewController: UIViewController {
    
    var presenter: StatisticPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    private func configureView() {
        view.backgroundColor = Assets.Colors.background
    }
}

//MARK: - StatisticViewProtocol

extension StatisticViewController: StatisticViewProtocol {
    
}
