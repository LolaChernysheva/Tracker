//
//  EmojiCell.swift
//  Tracker
//
//  Created by Lolita Chernysheva on 20.02.2024.
//  
//

import UIKit

struct EmogiCellViewModel {
    let emogi: String
    
    static let empty = EmogiCellViewModel(emogi: "")
}

class EmogiCell: UICollectionViewCell {
    
    static let reuseIdentifier = "EmogiCell"
    
    var viewModel: EmogiCellViewModel = .empty {
        didSet {
            emogiLabel.text = viewModel.emogi
        }
    }
    
    private let emogiLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .clear
        
        addSubview(emogiLabel)
        emogiLabel.textAlignment = .center
        emogiLabel.font = UIFont.systemFont(ofSize: 32)
        emogiLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emogiLabel.widthAnchor.constraint(equalToConstant: 32),
            emogiLabel.heightAnchor.constraint(equalToConstant: 38),
            emogiLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            emogiLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

