import UIKit

// Provides an input field to select an organization.
final class RepositoriesHeaderView: UIView {
    let textField = UITextField()
    let goButton = UIButton(type: .system)
    
    var onGoTapped: ((String) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        textField.layer.cornerRadius = 8
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter organization"
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textField)
        
        goButton.setTitle("Go", for: .normal)
        goButton.backgroundColor = .systemBlue
        goButton.setTitleColor(.white, for: .normal)
        goButton.layer.cornerRadius = 8
        goButton.clipsToBounds = true
        goButton.translatesAutoresizingMaskIntoConstraints = false
        goButton.addAction(UIAction { [weak self] _ in
            if let organization = self?.textField.text, !organization.isEmpty {
                self?.onGoTapped?(organization)
            }
        }, for: .touchUpInside)
        addSubview(goButton)
        
        // Layout constraints
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            textField.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            
            goButton.leadingAnchor.constraint(equalTo: textField.trailingAnchor, constant: 8),
            goButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            goButton.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            goButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            goButton.widthAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func setOrganization(_ organization: String) {
        textField.text = organization
    }
    
    func setError(_ hasError: Bool) {
        textField.layer.borderWidth = hasError ? 2 : 0
        textField.layer.borderColor = hasError ? UIColor.red.cgColor : UIColor.clear.cgColor
    }
}
