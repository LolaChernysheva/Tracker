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
        datePicker.datePickerMode = .date
        datePicker.date = model.date ?? Date() //MARK: - TODO
        return datePicker
    }()

    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        return collectionView
    }()
    
    private var model: TrackersScreenModel = .empty {
        didSet {
            setup()
        }
    }
    
    var presenter: TrackersPresenterProtocol!
    
    //MARK: - life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.setup()
        configureView()
    }
    
    //MARK: - private methods
    
    private func configureView() {
        view.backgroundColor = Assets.Colors.background
        if presenter.shouldShowBackground() {
            configureBackgroundView()
        }
        configureNavBar()
        configureCollectionView()
    }
    
    private func configureNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addAction))
        addBarButtonItem.tintColor = model.addBarButtonColor
        navigationItem.leftBarButtonItem = addBarButtonItem
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
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
    
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        setupCollectionViewConstraints()
    }
    
    private func setupCollectionViewConstraints() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setup() {
        title = model.title
    }
    
    //MARK: - objc methods
    
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

//MARK: - UICollectionViewDataSource

extension TrackersViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        model.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
