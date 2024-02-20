//
//  CreateTrackerViewController.swift
//  Tracker
//
//  Created by Lolita Chernysheva on 14.02.2024.
//  
//

import UIKit

protocol CreateTrackerViewProtocol: AnyObject {
    func displayData(model: CreateTrackerScreenModel)
    func showCreateActivityController(viewController: UIViewController)
}

final class CreateTrackerViewController: UIViewController {
    
    private let stackView = UIStackView()
    private let createHabitButton = UIButton()
    private let createEventButton = UIButton()
    
    var presenter: CreateTrackerPresenterProtocol!
    
    private var model: CreateTrackerScreenModel = .empty {
        didSet {
            setup()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.setup()
        configureView()
    }
    
    private func setup() {
        title = model.title
        view.backgroundColor = model.backGroundColor
        createHabitButton.setTitle(model.habitButtonTitle, for: .normal)
        createEventButton.setTitle(model.eventButtonTitle, for: .normal)
    }
    
    private func configureView() {
        setupStackView()
        setupCreateHabitButton()
        setupCreateEventButton()
    }
    
    private func setupStackView() {
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 16
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .insets),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -(.insets)),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupCreateHabitButton() {
        stackView.addArrangedSubview(createHabitButton)
        createHabitButton.backgroundColor = .buttons
        
        createHabitButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            createHabitButton.heightAnchor.constraint(equalToConstant: .buttonHeight)
        ])
        createHabitButton.layer.cornerRadius = .cornerRadius
        createHabitButton.clipsToBounds = true
        
        createHabitButton.addTarget(self, action: #selector(createHabit), for: .touchUpInside)
    }
    
    private func setupCreateEventButton() {
        stackView.addArrangedSubview(createEventButton)
        createEventButton.backgroundColor = .buttons
        
        createEventButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            createEventButton.heightAnchor.constraint(equalToConstant: .buttonHeight)
        ])
        createEventButton.layer.cornerRadius = .cornerRadius
        createEventButton.clipsToBounds = true
        createEventButton.addTarget(self, action: #selector(createEvent), for: .touchUpInside)
    }
    
    @objc private func createHabit() {
        presenter.createHabit()
    }
    
    @objc private func createEvent() {
        presenter.createEvent()
    }
}

extension CreateTrackerViewController: CreateTrackerViewProtocol {
    func displayData(model: CreateTrackerScreenModel) {
        self.model = model
    }
    
    func showCreateActivityController(viewController: UIViewController) {
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

private extension CGFloat {
    static let insets: CGFloat = 20
    static let cornerRadius: CGFloat = 16
    static let buttonHeight: CGFloat = 60
}
