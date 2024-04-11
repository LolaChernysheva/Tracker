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
    var isPinned: Bool
    var daysCount: Int?
    var color: UIColor?
    var doneButtonHandler: TrackerCollectionViewCell.ActionClousure
    var pinHandler: (Bool) -> Void
    var isCompleted: Bool
    var deleteTrackerHandler: () -> Void
    var editTrackerHandler: () -> Void
    
    init(
        emoji: String?,
        title: String?,
        isPinned: Bool,
        daysCount: Int?,
        color: UIColor?,
        doneButtonHandler: @escaping TrackerCollectionViewCell.ActionClousure,
        pinHandler: @escaping (Bool) -> Void,
        isCompleted: Bool,
        deleteTrackerHandler: @escaping () -> Void,
        editTrackerHandler: @escaping () -> Void
    ) {
        self.emoji = emoji
        self.title = title
        self.isPinned = isPinned
        self.daysCount = daysCount
        self.color = color
        self.doneButtonHandler = doneButtonHandler
        self.pinHandler = pinHandler
        self.isCompleted = isCompleted
        self.deleteTrackerHandler = deleteTrackerHandler
        self.editTrackerHandler = editTrackerHandler
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
    private var togglePinAction: ((Bool) -> Void)?
    private var deleteTrackerHandler: (() -> Void)?
    private var editTrackerHandler: (() -> Void)?
    
    var viewModel: TrackerCollectionViewCellViewModel? {
        didSet {
            setup()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
        setupContextMenu()
        backgroundColor = .clear
    }

    private func setup() {
        setupPinImageView()
        setupTitleLabel()
        setupDaysContLabel()
        setupContainerView()
        setupDoneButton()
        setupEmogiLabel()
        deleteTrackerHandler = viewModel?.deleteTrackerHandler
        editTrackerHandler = viewModel?.editTrackerHandler
    }
    
    private func setupContainerView() {
        guard let viewModel else { return }
        containerView.backgroundColor = viewModel.color
    }
    
    private func setupDaysContLabel() {
        guard let viewModel else { return }
        let daysCount = viewModel.daysCount ?? 0
        let daysWord = correctDaysForm(daysCount: daysCount)
        daysCountLabel.text = "\(daysCount) \(daysWord)"
    }
    
    private func setupTitleLabel() {
        guard let viewModel else { return }
        titleLabel?.text = viewModel.title
        titleLabel.numberOfLines = 2
        titleLabel.contentMode = .bottom
    }
    
    private func setupPinImageView() {
        guard let viewModel else { return }
        pinImageView.isHidden = !(viewModel.isPinned)
        pinImageView.image = viewModel.isPinned
        ? UIImage(systemName: "pin.fill")?
            .withTintColor(.white, renderingMode: .alwaysOriginal)
        : nil
        togglePinAction = viewModel.pinHandler
       
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
        doneButton.backgroundColor = viewModel.color
        doneButton.alpha = viewModel.isCompleted ? 0.3 : 1
        
        doneButton.layer.cornerRadius = doneButton.frame.width / 2
        doneButton.clipsToBounds = true
        
        doneAction = viewModel.doneButtonHandler
    }
    
    private func setupContextMenu() {
        let interaction = UIContextMenuInteraction(delegate: self)
        containerView.addInteraction(interaction)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setup()
    }
    @IBAction func doneButtonAction(_ sender: Any) {
        doneAction()
    }
}

private extension TrackerCollectionViewCell {
    func correctDaysForm(daysCount: Int) -> String {
        let lastDigit = daysCount % 10
        let lastTwoDigits = daysCount % 100
        
        if lastTwoDigits >= 11 && lastTwoDigits <= 19 {
            return "дней"
        } else if lastDigit == 1 {
            return "день"
        } else if lastDigit >= 2 && lastDigit <= 4 {
            return "дня"
        } else {
            return "дней"
        }
    }
}

//MARK: - UIContextMenuInteractionDelegate

extension TrackerCollectionViewCell: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(
        _ interaction: UIContextMenuInteraction,
        configurationForMenuAtLocation location: CGPoint
    ) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [ weak self ] suggestedActions -> UIMenu? in
            guard let self else { return .none }
            let pinAction = UIAction(
                title: (self.viewModel?.isPinned ?? false)
                ? NSLocalizedString("Unpin", comment: "")
                : NSLocalizedString("Pin", comment: "")
            ) { [ weak self ] _ in
                guard let self else { return }
                self.viewModel?.pinHandler(!(viewModel?.isPinned ?? false))
            }
            
            let editAction = UIAction(
                title: NSLocalizedString("Edit", comment: "")
            ) { [ weak self ] _ in
                guard let self else { return }
                self.viewModel?.editTrackerHandler()
            }
            
            let deleteAction = UIAction(
                title: NSLocalizedString("Delete", comment: ""),
                attributes: .destructive
            ) {  [ weak self ] _ in
                self?.viewModel?.deleteTrackerHandler()
            }
            return UIMenu(title: "", children: [pinAction, editAction, deleteAction])
        }
    }
}
