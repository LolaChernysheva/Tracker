//
//  CreateActivityViewController.swift
//  Tracker
//
//  Created by Lolita Chernysheva on 19.02.2024.
//  
//

import UIKit

protocol CreateActivityViewProtocol: AnyObject {
    func displayData(screenModel: CreateActivityScreenModel, reloadTableData: Bool, reloadCollectionData: Bool)
}

final class CreateActivityViewController: UIViewController {
    
    typealias TableData = CreateActivityScreenModel.TableData
    typealias CollectionData = CreateActivityScreenModel.CollectionData
    
    var presenter: CreateActivityPresenterProtocol!
    
    private var screenModel: CreateActivityScreenModel = .empty {
        didSet {
            setup()
        }
    }
    
    private let stackView = UIStackView()
    private let cancelButton = UIButton()
    private let createButton = UIButton()
    
    private var tableView = UITableView(frame: .zero, style: .insetGrouped)
    private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override func viewDidLoad() {
        presenter.setup()
        configureView()
    }
    
    private func setup() {
        title = screenModel.title
        view.backgroundColor = .background
        createButton.setTitle(screenModel.createButtonTitle, for: .normal)
        cancelButton.setTitle(screenModel.cancelButtonTitle, for: .normal)
    }
    
    private func configureView() {
        configureStackView()
        setupTableView()
        setupCollectionView()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SubtitledDetailTableViewCell.self, forCellReuseIdentifier: SubtitledDetailTableViewCell.reuseIdentifier)
        tableView.register(TextFieldCell.self, forCellReuseIdentifier: TextFieldCell.reuseIdentifier)
        setupTableViewConstraints()
    }
    
    private func setupTableViewConstraints() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 250)
        ])
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(EmogiCell.self, forCellWithReuseIdentifier: EmogiCell.reuseIdentifier)
        collectionView.register(ColorCell.self,  forCellWithReuseIdentifier: ColorCell.reuseIdentifier)
        collectionView.register(SupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SupplementaryView.reuseIdentifier
        )
        setupCollectionViewConstraints()
    }
    
    private func setupCollectionViewConstraints() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 32),
            collectionView.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -16)
        ])
    }
    
    private func tableDataCell(indexPath: IndexPath) -> TableData.Cell {
        let section = screenModel.tableData.sections[indexPath.section]
        switch section {
        case let .simple(cells):
            return cells[indexPath.row]
        }
    }
    
    private func collectionDataCell(indexPath: IndexPath) -> CollectionData.Cell {
        let section = screenModel.collectionData.sections[indexPath.section]
        
        switch section {
        case .headeredSection(_, cells: let cells):
            return cells[indexPath.row]
        }
    }
    
    private func configureStackView() {
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        stackView.addArrangedSubview(cancelButton)
        stackView.addArrangedSubview(createButton)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        setupCreateButton()
        setupCancelButton()
    }
    
    private func setupCreateButton() {
        createButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            createButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        createButton.backgroundColor = .buttons //MARK: - TODO set color and restrict UI
        createButton.layer.cornerRadius = 16
        createButton.clipsToBounds = true
        
    }
    
    private func setupCancelButton() {
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cancelButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        cancelButton.layer.cornerRadius = 16
        cancelButton.clipsToBounds = true
        cancelButton.setTitleColor(.tomato, for: .normal)
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.tomato.cgColor
    }
}


//MARK: - CreateActivityViewProtocol

extension CreateActivityViewController: CreateActivityViewProtocol {
    func displayData(screenModel: CreateActivityScreenModel, reloadTableData: Bool, reloadCollectionData: Bool) {
        self.screenModel = screenModel
        if reloadTableData {
            tableView.reloadData()
        }
        
        if reloadCollectionData {
            collectionView.reloadData()
        }
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension CreateActivityViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = tableDataCell(indexPath: indexPath)
        let cell: UITableViewCell
        
        switch cellType {
            
        case let .textFieldCell(model):
            guard let textFieldCell = tableView.dequeueReusableCell(withIdentifier: TextFieldCell.reuseIdentifier, for: indexPath) as? TextFieldCell else { return UITableViewCell() }
            textFieldCell.viewModel = model
            cell = textFieldCell
        case let .detailCell(model):
            guard let detailCell = tableView.dequeueReusableCell(withIdentifier: SubtitledDetailTableViewCell.reuseIdentifier, for: indexPath) as? SubtitledDetailTableViewCell else { return UITableViewCell() }
            detailCell.viewModel = model
            cell = detailCell
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        screenModel.tableData.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch screenModel.tableData.sections[section] {
        case let .simple(cells):
            cells.count
        }
    }
    
}

//MARK: - UICollectionViewDataSource

extension CreateActivityViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        screenModel.collectionData.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch screenModel.collectionData.sections[section] {
            
        case .headeredSection(_, cells: let cells):
            cells.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellType = collectionDataCell(indexPath: indexPath)
        let cell: UICollectionViewCell
        
        switch cellType {
        case let .emogi(model):
            guard let emogiCell = collectionView.dequeueReusableCell(withReuseIdentifier: EmogiCell.reuseIdentifier, for: indexPath) as? EmogiCell else { return UICollectionViewCell() }
            emogiCell.viewModel = model
            cell = emogiCell
        case let .color(model):
            guard let colorCell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCell.reuseIdentifier, for: indexPath) as? ColorCell else { return UICollectionViewCell() }
            colorCell.viewModel = model
            cell = colorCell
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SupplementaryView.reuseIdentifier, for: indexPath) as? SupplementaryView else { return UICollectionReusableView() }
            
            switch screenModel.collectionData.sections[indexPath.section] {
            case .headeredSection(header: let header, _):
                headerView.titleLabel.text = header
                return headerView
            }
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension CreateActivityViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 52, height: 52)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
