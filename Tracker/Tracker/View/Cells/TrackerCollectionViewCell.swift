//
//  TrackerCollectionViewCell.swift
//  Tracker
//
//  Created by Lolita Chernysheva on 11.02.2024.
//  
//

import UIKit

struct TrackerCollectionViewCellViewModel {
    var emoji: String?
    var title: String?
    var isPinned: Bool?
    var daysCount: Int?
    var color: UIColor?
    var doneButtonHandler: TrackerCollectionViewCell.ActionClousure
    var isCompleted: Bool
    
    init(
        emoji: String?,
        title: String?,
        isPinned: Bool?,
        daysCount: Int?,
        color: UIColor?,
        doneButtonHandler: @escaping TrackerCollectionViewCell.ActionClousure,
        isCompleted: Bool
    ) {
        self.emoji = emoji
        self.title = title
        self.isPinned = isPinned
        self.daysCount = daysCount
        self.color = color
        self.doneButtonHandler = doneButtonHandler
        self.isCompleted = isCompleted
    }
}

class TrackerCollectionViewCell: UICollectionViewCell {
    
    typealias ActionClousure = () -> Void
    
    static let reuseIdentifier = "TrackerCollectionViewCell"
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pinImageView: UIImageView!
    @IBOutlet weak var daysCountLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    
    private var doneAction: ActionClousure = {}
    
    var viewModel: TrackerCollectionViewCellViewModel? {
        didSet {
            setup()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
        containerView.backgroundColor = .orange
    }

    private func setup() {
        guard let viewModel else { return }
        if viewModel.isPinned == false {
            pinImageView.isHidden = true
        }
        emojiLabel?.text = viewModel.emoji
        titleLabel?.text = viewModel.title
        pinImageView.isHidden = !(viewModel.isPinned ?? false)
        daysCountLabel.text = "\(viewModel.daysCount ?? 0) дней"
        containerView.backgroundColor = viewModel.color
        doneAction = viewModel.doneButtonHandler
        doneButton.setTitle("", for: .normal)
        doneButton.tintColor = viewModel.color
        pinImageView.isHidden = false

        let buttonImage = viewModel.isCompleted ? UIImage(systemName: "checkmark") : UIImage(systemName: "plus")
        doneButton.setImage(buttonImage, for: .normal)
        
        setupEmogiLabel()
    }
    
    private func setupEmogiLabel() {
        emojiLabel.layer.cornerRadius = emojiLabel.frame.width / 2
        emojiLabel.clipsToBounds = true
        emojiLabel.backgroundColor = .background.withAlphaComponent(0.3)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setup()
    }
    @IBAction func doneButtonAction(_ sender: Any) {
        doneAction()
    }
}
