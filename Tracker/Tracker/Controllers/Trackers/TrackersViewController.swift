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
    func showCreateController(viewController: UIViewController)
}

final class TrackersViewController: UIViewController {
    
    typealias Cell = TrackersScreenModel.CollectionData.Cell
    typealias Section = TrackersScreenModel.CollectionData.Section
    
    private var backgroundView = BackgroundView()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
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
        collectionView.register(UINib(nibName: "TrackerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: TrackerCollectionViewCell.reuseIdentifier)

        
        collectionView.register(
            SupplementaryView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SupplementaryView.reuseIdentifier
        )

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
    
    private func collectionDataCell(indexPath: IndexPath) -> Cell {
        let section = model.collectionData.sections[indexPath.section]
        switch section {
        case .headeredSection(_, cells: let cells):
            return cells[indexPath.row]
        }
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
    
    func showCreateController(viewController: UIViewController) {
        let nc = UINavigationController(rootViewController: viewController)
        navigationController?.present(nc, animated: true)
    }
}

//MARK: - UICollectionViewDataSource

extension TrackersViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellType = collectionDataCell(indexPath: indexPath)
        let cell: UICollectionViewCell
        
        switch cellType {
        case let .trackerCell(model):
            guard let trackerCell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCollectionViewCell.reuseIdentifier, for: indexPath) as? TrackerCollectionViewCell
            else { return UICollectionViewCell() }
            trackerCell.viewModel = model
            cell = trackerCell
        }
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        model.collectionData.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch model.collectionData.sections[section] {
        case .headeredSection(_, cells: let cells):
            return cells.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SupplementaryView.reuseIdentifier, for: indexPath) as? SupplementaryView else { return UICollectionReusableView() }
            
            switch model.collectionData.sections[indexPath.section] {
            case .headeredSection(header: let header, _):
                headerView.titleLabel.text = header
                return headerView
            }
        }
        return UICollectionReusableView()
    }
}

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 200, height: 200)
    }
    
}
