//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Lolita Chernysheva on 09.02.2024.
//  
//

import UIKit

protocol TrackersViewProtocol: AnyObject {
    func displayData(model: TrackersScreenModel, reloadData: Bool)
}

final class TrackersViewController: UIViewController {
    
    private var backgroundView = BackgroundView()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.date = model.date ?? Date() //MARK: - TODO
        return datePicker
    }()
    
    private lazy var datePickerView: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .center
        textField.inputView = datePicker
        return textField
    }()
    
    private var model: TrackersScreenModel = .empty {
        didSet {
            setup()
        }
    }
    
    var presenter: TrackersPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.setup()
        configureView()
        configureNavBar()
    }
    
    private func configureView() {
        view.backgroundColor = Assets.Colors.background
        if presenter.shouldShowBackground() {
            configureBackgroundView()
        }
    }
    
    private func configureNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        let addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addAction))
        addBarButtonItem.tintColor = model.addBarButtonColor
        navigationItem.leftBarButtonItem = addBarButtonItem
        
        let rightBarButtonItem = UIBarButtonItem(customView: datePickerView)
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    private func configureBackgroundView() {
        view.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backgroundView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            backgroundView.widthAnchor.constraint(equalToConstant: 200),
            backgroundView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
    }
    
    private func setup() {
        title = model.title
    }
    
    @objc private func addAction() {
        presenter.addTracker()
    }
}

//MARK: - TrackersViewProtocol

extension TrackersViewController: TrackersViewProtocol {
    func displayData(model: TrackersScreenModel, reloadData: Bool) {
        self.model = model
    }
}
