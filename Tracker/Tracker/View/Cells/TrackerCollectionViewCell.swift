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
    var doneButtonHandler: TrackerCollectionViewCell.ActionClousure?
    
    init(
        emoji: String?,
        title: String?,
        isPinned: Bool?,
        daysCount: Int?,
        color: UIColor?,
        doneButtonHandler: TrackerCollectionViewCell.ActionClousure?) {
        self.emoji = emoji
        self.title = title
        self.isPinned = isPinned
        self.daysCount = daysCount
        self.color = color
        self.doneButtonHandler = doneButtonHandler
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
    
    private var doneAction: ActionClousure?
    
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
            pinImageView.removeFromSuperview()
        }
        emojiLabel?.text = viewModel.emoji
        titleLabel?.text = viewModel.title
        pinImageView.isHidden = !(viewModel.isPinned ?? false)
        daysCountLabel.text = "\(viewModel.daysCount ?? 0) дней" //MARK: - TODO
        containerView.backgroundColor = viewModel.color
        doneAction = viewModel.doneButtonHandler
        doneButton.setTitle("", for: .normal)
        doneButton.tintColor = viewModel.color
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setup()
    }
}
