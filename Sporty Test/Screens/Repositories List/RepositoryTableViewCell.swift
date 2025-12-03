import UIKit
import Combine

/// A cell displaying the basic information of a GitHub repository.
final class RepositoryTableViewCell: UITableViewCell {
    
    var starCancellable: AnyCancellable?
    
    /// The name of the repository.
    var name: String? {
        get {
            nameAndStarsView.name
        }
        set {
            nameAndStarsView.name = newValue
        }
    }

    /// The description of the repository.
    var descriptionText: String? {
        get {
            descriptionLabel.text
        }
        set {
            descriptionLabel.text = newValue
        }
    }

    /// The star count of the repository. This text should be pre-formatted.
    var starCountText: String? {
        get {
            nameAndStarsView.starCountText
        }
        set {
            nameAndStarsView.starCountText = newValue
        }
    }

    private let nameAndStarsView = RepositoryTableViewCellNameStarsView()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(nameAndStarsView)
        contentView.addSubview(descriptionLabel)

        nameAndStarsView.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameAndStarsView
                .leadingAnchor
                .constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            nameAndStarsView
                .topAnchor
                .constraint(equalToSystemSpacingBelow: contentView.layoutMarginsGuide.topAnchor, multiplier: 1),
            nameAndStarsView
                .trailingAnchor
                .constraint(lessThanOrEqualTo: contentView.layoutMarginsGuide.trailingAnchor),

            descriptionLabel
                .leadingAnchor
                .constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            descriptionLabel
                .firstBaselineAnchor
                .constraint(equalToSystemSpacingBelow: nameAndStarsView.bottomAnchor, multiplier: 1),
            descriptionLabel
                .trailingAnchor
                .constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),

            contentView
                .layoutMarginsGuide
                .bottomAnchor
                .constraint(equalToSystemSpacingBelow: descriptionLabel.lastBaselineAnchor, multiplier: 1),
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        starCancellable?.cancel()
        starCancellable = nil
    }
}
