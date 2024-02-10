//
//  BackgroundView.swift
//  Tracker
//
//  Created by Lolita Chernysheva on 10.02.2024.
//  
//

import UIKit

final class BackgroundView: UIView {
    
    private let imageView:  UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = Assets.Images.backgroundError
        return imageView
    }()
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "YS-Display-Medium", size: 12)
        label.text = "Что будем отслеживать?"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubview(imageView)
        addSubview(textLabel)
        
        setupImageViewConstraints()
        setupTextLabelConstraints()
    }
    
    private func setupImageViewConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: .imageViewWidth),
            imageView.heightAnchor.constraint(equalToConstant: .imageViewHeight)
        ])
    }
    
    private func setupTextLabelConstraints() {
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: .insets),
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            textLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            textLabel.heightAnchor.constraint(equalToConstant: .textLabelHeight)
        ])
    }
    
}

private extension CGFloat {
    static let imageViewWidth = 80.0
    static let imageViewHeight = 80.0
    static let insets = 8.0
    static let textLabelHeight = 20.0
}
