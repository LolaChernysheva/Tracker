//
//  ColorCell.swift
//  Tracker
//
//  Created by Lolita Chernysheva on 20.02.2024.
//  
//

import UIKit

struct ColorCellViewModel {
    let color: UIColor
    
    static let empty = ColorCellViewModel(color: .clear)
}

class ColorCell: UICollectionViewCell {
    
    static let reuseIdentifier = "ColorCell"
    
    private let colorView = UIView()
    
    var viewModel: ColorCellViewModel = .empty {
        didSet {
            colorView.backgroundColor = viewModel.color
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .clear
        
        colorView.layer.cornerRadius = .cornerRadius
        colorView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(colorView)
        
        NSLayoutConstraint.activate([
            colorView.widthAnchor.constraint(equalToConstant: .colorViewWidthHeight),
            colorView.heightAnchor.constraint(equalToConstant: .colorViewWidthHeight),
            colorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

private extension CGFloat {
    static let cornerRadius = 8.0
    static let colorViewWidthHeight = 40.0
}
