//
//  TrackerCollectionViewCell.swift
//  Tracker
//
//  Created by Lolita Chernysheva on 11.02.2024.
//  
//

import UIKit

struct TrackerCollectionViewCellViewModel {
    let emoji: String
    let title: String
    let isPinned: Bool
    let daysCount: Int
    let doneButtonHandler: () -> Void
    
    init(
        emoji: String,
        title: String,
        isPinned: Bool,
        daysCount: Int,
        doneButtonHandler: @escaping () -> Void
    ) {
        self.emoji = emoji
        self.title = title
        self.isPinned = isPinned
        self.daysCount = daysCount
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
            emojiLabel.text = viewModel?.emoji
            titleLabel.text = viewModel?.title
            pinImageView.isHidden = !(viewModel?.isPinned ?? false)
            daysCountLabel.text = "\(viewModel?.daysCount) дней" //MARK: - TODO
            doneAction = viewModel?.doneButtonHandler
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
