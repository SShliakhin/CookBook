//
//  InstructionCell.swift
//  CookBook
//
//  Created by Анастасия Бегинина on 09.12.2022.
//

import UIKit

// MARK: - Cell for recipeTableView in DetailViewController
class InstructionCell: UITableViewCell{
    static let rowHeight: CGFloat = 100
    static let reuseID = String(describing: InstructionCell.self)
    
    let imageChecked = UIImage(systemName: "checkmark.square", withConfiguration: Theme.mediumConfiguration)
    let imageUnchecked = UIImage(systemName: "square", withConfiguration: Theme.mediumConfiguration)
    
    private var isChecked = false
    
    let networkLoader = NetworkLoader(networkClient: NetworkClient())
    
    // MARK: - UI Elements
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = Theme.cbYellow20
        stackView.layer.cornerRadius = 5
        stackView.layer.masksToBounds = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let mainTextLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.numberOfLines = 0
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var checkboxButton: UIButton = {
        let button = UIButton()
        button.tintColor = Theme.cbYellow50
        button.imageView?.contentMode = .scaleAspectFill
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        applyStyle()
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Style, layout and configuration
extension InstructionCell {
    private func setup() {
        checkboxButton.addTarget(self, action:  #selector(CheckboxClicked), for: .touchUpInside)
    }
    
    private func applyStyle(){
    }
    
    private func layout() {
        arrangeStackView(for: stackView,
                         subviews: [mainTextLabel, timeLabel],
                         spacing: 10,
                         axis: .vertical,
                         aligment: .center)
        contentView.addSubview(checkboxButton)
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            stackView.leadingAnchor.constraint(equalTo: checkboxButton.trailingAnchor, constant: 5),
            stackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),
            
            checkboxButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkboxButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            checkboxButton.widthAnchor.constraint(equalToConstant: 30),
            checkboxButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func configure(recipeInstruction: InstructionModel){
        mainTextLabel.text = recipeInstruction.step
        timeLabel.text = "\(recipeInstruction.minutes) min"
        self.isChecked = recipeInstruction.isChecked
        checkboxButton.setImage(isChecked ? imageChecked : imageUnchecked, for: .normal)
    }
}

// MARK: - Private service functions
extension InstructionCell{
    private func arrangeStackView(
        for stackView: UIStackView,
        subviews: [UIView],
        spacing: CGFloat = 0,
        axis: NSLayoutConstraint.Axis = .horizontal,
        distribution: UIStackView.Distribution = .fill,
        aligment: UIStackView.Alignment = .fill
    ) {
        stackView.axis = axis
        stackView.spacing = spacing
        stackView.distribution = distribution
        stackView.alignment = aligment
        
        subviews.forEach { item in
            item.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(item)
        }
    }
}

// MARK: - Actions
extension InstructionCell{
    @objc private func CheckboxClicked() {
        isChecked.toggle()
        checkboxButton.setImage(isChecked ? imageChecked : imageUnchecked, for: .normal)
    }
}
