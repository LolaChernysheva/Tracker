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
        setupPinImageView()
        setupTitleLabel()
        setupDaysContLabel()
        setupContainerView()
        setupDoneButton()
        setupEmogiLabel()
    }
    
    private func setupContainerView() {
        guard let viewModel else { return }
        containerView.backgroundColor = viewModel.color
    }
    
    private func setupDaysContLabel() {
        guard let viewModel else { return }
        daysCountLabel.text = "\(viewModel.daysCount ?? 0) дней"
    }
    
    private func setupTitleLabel() {
        guard let viewModel else { return }
        titleLabel?.text = viewModel.title
        titleLabel.numberOfLines = 2
        titleLabel.contentMode = .bottom
    }
    
    private func setupPinImageView() {
        guard let viewModel else { return }
        if viewModel.isPinned == false {
            pinImageView.isHidden = true
        }
        pinImageView.isHidden = !(viewModel.isPinned ?? false)
       
    }
    private func setupEmogiLabel() {
        guard let viewModel else { return }
        emojiLabel?.text = viewModel.emoji
        emojiLabel.layer.cornerRadius = emojiLabel.frame.width / 2
        emojiLabel.clipsToBounds = true
        emojiLabel.backgroundColor = .background.withAlphaComponent(0.3)
    }
    
    private func setupDoneButton() {
        guard let viewModel else { return }
        let buttonImage = viewModel.isCompleted ? Assets.Images.done: Assets.Images.plus
        doneButton.setImage(buttonImage, for: .normal)
        doneButton.setTitle("", for: .normal)
        doneButton.tintColor = viewModel.color
        doneButton.alpha = viewModel.isCompleted ? 0.3 : 1
        
        doneButton.layer.cornerRadius = doneButton.frame.width / 2
        doneButton.clipsToBounds = true
        
        doneAction = viewModel.doneButtonHandler
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setup()
    }
    @IBAction func doneButtonAction(_ sender: Any) {
        doneAction()
    }
}
