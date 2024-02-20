//
//  TextFieldCell.swift
//  Tracker
//
//  Created by Lolita Chernysheva on 19.02.2024.
//  
//

import UIKit

struct TextFieldCellViewModel {
    let placeholderText: String
    let inputText: String
    
    let textDidChanged: (String) -> Void
    
    static let empty: TextFieldCellViewModel = .init(placeholderText: "", inputText: "", textDidChanged: { _ in })
}

final class TextFieldCell: UITableViewCell {
    
    static let reuseIdentifier = "TextFieldCell"
    
    let textField = UITextField()
    
    var viewModel: TextFieldCellViewModel = .empty {
        didSet {
            setup()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        textField.delegate = self
        configureTextField()
        setupTextFieldConstraints()
    }
    
    private func setup() {
        configureTextField()
    }
    
    private func configureTextField() {
        textField.placeholder = viewModel.placeholderText
        textField.text = viewModel.inputText
        textField.addTarget(self, action: #selector(onEditingChanged), for: .editingChanged)
    }
    
    private func setupTextFieldConstraints() {
        contentView.addSubview(textField)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .topInset),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: .bottomInset),
            textField.leadingAnchor.constraint(equalTo: contentView.leftAnchor, constant: .leadingInset),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: .trailingInset)
        ])
    }
    
    @objc private func onEditingChanged(_ textField: UITextField) {
        viewModel.textDidChanged(textField.text ?? "")
    }
}

//MARK: - UITextFieldDelegate

extension TextFieldCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        return updatedText.count <= .textFieldNumberOfSymbolsAllowed
    }
}

private extension CGFloat {
    static let topInset: CGFloat = 6
    static let bottomInset: CGFloat = -6
    static let leadingInset: CGFloat = 16
    static let trailingInset: CGFloat = 40
}

private extension Int {
    static let textFieldNumberOfSymbolsAllowed = 38
}
