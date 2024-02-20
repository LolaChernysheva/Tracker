//
//  SubtitledDetailTableViewCell.swift
//  Tracker
//
//  Created by Lolita Chernysheva on 19.02.2024.
//  
//

import UIKit

struct SubtitledDetailTableViewCellViewModel {
    let title: String
    let subtitle: String?
    
    static let empty: SubtitledDetailTableViewCellViewModel = .init(title: "", subtitle: "")
}

final class SubtitledDetailTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "SubtitledDetailTableViewCell"
    
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    let stackView = UIStackView()
    
    var viewModel: SubtitledDetailTableViewCellViewModel = .empty {
        didSet {
            setup()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
        configureView()
    }
    
    private func setup() {
        if viewModel.subtitle == nil {
            subtitleLabel.removeFromSuperview()
        }
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
    }
    
    private func configureView() {
        contentView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 15),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -56)
        ])
        
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 2
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.heightAnchor.constraint(equalToConstant: 22)
        ])
        
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subtitleLabel.heightAnchor.constraint(equalToConstant: 22)
        ])
    }
}
