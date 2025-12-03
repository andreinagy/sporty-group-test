import UIKit

final class RepositoryTableViewCellNameStarsView: UIView {
    var name: String? {
        get {
            nameLabel.text
        }
        set {
            nameLabel.text = newValue
        }
    }

    var starCountText: String? {
        get {
            starCountLabel.text
        }
        set {
            starCountLabel.text = newValue
        }
    }

    private let nameLabel: UILabel = {
        let label = UILabel()
        let baseFont = UIFont.preferredFont(forTextStyle: .body)
        let boldDescriptor = baseFont.fontDescriptor.withSymbolicTraits(.traitBold)
        label.font = boldDescriptor.flatMap { UIFont(descriptor: $0, size: 0) } ?? baseFont
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    private let starImageView: UIImageView = {
        let imageView = UIImageView()
        let configuration = UIImage.SymbolConfiguration(font: .preferredFont(forTextStyle: .caption1))
        imageView.image = UIImage(systemName: "star.fill", withConfiguration: configuration)
        imageView.tintColor = .systemYellow
        return imageView
    }()

    private let starCountLabel: UILabel = {
        let label = UILabel()
        label.font = .monospacedSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .caption1).pointSize, weight: .regular)
        label.textColor = .secondaryLabel
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    private var inlineConstraints: [NSLayoutConstraint] = []
    private var stackedConstraints: [NSLayoutConstraint] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        starImageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        starCountLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

        addSubview(nameLabel)
        addSubview(starImageView)
        addSubview(starCountLabel)

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        starImageView.translatesAutoresizingMaskIntoConstraints = false
        starCountLabel.translatesAutoresizingMaskIntoConstraints = false

        inlineConstraints = [
            nameLabel
                .leadingAnchor
                .constraint(equalTo: leadingAnchor),
            nameLabel
                .topAnchor
                .constraint(equalTo: topAnchor),

            starImageView
                .leadingAnchor
                .constraint(equalToSystemSpacingAfter: nameLabel.trailingAnchor, multiplier: 1),
            starImageView
                .centerYAnchor
                .constraint(equalTo: nameLabel.centerYAnchor),

            starCountLabel
                .leadingAnchor
                .constraint(equalTo: starImageView.trailingAnchor, constant: 4),
            starCountLabel
                .centerYAnchor
                .constraint(equalTo: nameLabel.centerYAnchor),
            starCountLabel
                .trailingAnchor
                .constraint(lessThanOrEqualTo: trailingAnchor),

            bottomAnchor
                .constraint(equalTo: nameLabel.bottomAnchor),
        ]

        stackedConstraints = [
            nameLabel
                .leadingAnchor
                .constraint(equalTo: leadingAnchor),
            nameLabel
                .topAnchor
                .constraint(equalTo: topAnchor),
            nameLabel
                .trailingAnchor
                .constraint(equalTo: trailingAnchor),

            starImageView
                .leadingAnchor
                .constraint(equalTo: leadingAnchor),
            starImageView
                .topAnchor
                .constraint(equalToSystemSpacingBelow: nameLabel.bottomAnchor, multiplier: 1),

            starCountLabel
                .leadingAnchor
                .constraint(equalTo: starImageView.trailingAnchor, constant: 4),
            starCountLabel
                .centerYAnchor
                .constraint(equalTo: starImageView.centerYAnchor),
            starCountLabel
                .trailingAnchor
                .constraint(lessThanOrEqualTo: trailingAnchor),

            bottomAnchor
                .constraint(equalTo: starImageView.bottomAnchor),
        ]

        NSLayoutConstraint.activate(inlineConstraints)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // Check if nameLabel text fits on one line
        let nameLabelSize = nameLabel.sizeThatFits(CGSize(width: bounds.width - 8, height: .greatestFiniteMagnitude))
        let availableWidth = bounds.width - nameLabelSize.height - 8 // account for star icon and spacing
        let fitsInline = nameLabelSize.width <= availableWidth

        if fitsInline && inlineConstraints.first?.isActive == false {
            // Switch to inline layout
            NSLayoutConstraint.deactivate(stackedConstraints)
            NSLayoutConstraint.activate(inlineConstraints)
        } else if !fitsInline && inlineConstraints.first?.isActive == true {
            // Switch to stacked layout
            NSLayoutConstraint.deactivate(inlineConstraints)
            NSLayoutConstraint.activate(stackedConstraints)
        }
    }
}

