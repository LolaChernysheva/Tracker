//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Lolita Chernysheva on 09.02.2024.
//  
//

import UIKit

protocol TrackersViewProtocol: AnyObject {
    
}

final class TrackersViewController: UIViewController {
    
    var presenter: TrackersPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

//MARK: - TrackersViewProtocol

extension TrackersViewController: TrackersViewProtocol {
    
}
