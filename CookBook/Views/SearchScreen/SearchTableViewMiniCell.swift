import UIKit

final class SearchTableViewMiniCell: UITableViewCell {
    
    let networkClient = NetworkClient()
    
    private lazy var searchImageView: SearchImageView = {
        return SearchImageView(frame: .zero)
    }()
    private lazy var recipeLabel: UILabel = {
        var view = UILabel()
        view.text = "Title"
        view.numberOfLines = 4
        view.font = .preferredFont(forTextStyle: .headline)
        view.adjustsFontForContentSizeCategory = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var likesStackView: ImageLabelStack = {
        let view = ImageLabelStack()
        view.setImageWithConfiguration(name: "hand.thumbsup.fill", configuration: UIImage.SymbolConfiguration(font: .preferredFont(forTextStyle: .headline)))
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return view
    }()
    private lazy var likeButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(font: .preferredFont(forTextStyle: .headline))), for: .normal)
        view.tintColor = .systemRed
        view.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        view.sizeToFit()
        view.setTitleColor(.label, for: .normal)
        view.layer.borderColor = UIColor.systemRed.cgColor
        view.layer.borderWidth = 0.25
        view.layer.cornerRadius = 10
        view.layer.cornerCurve = .continuous
        view.layer.masksToBounds = true
        view.addTarget(self, action: #selector(favoriteButtonPressed), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        searchImageView.prepareForReuse()
    }
}

// MARK: - Public func

extension SearchTableViewMiniCell {
    func configure(recipe: SearchResult?) {
        guard let recipe = recipe else { return }
        let names = ["Ingrediens", "Calories", "Minutes"]
        
        let recipeString = recipe.title + "\n"
        let ingidientsString = String(recipe.nutrition.ingredients.count) + " \(names[0])\n"
        let caloriesString = String(Int(recipe.nutrition.nutrients[0].amount)) + " \(names[1])\n"
        let timeString = String(recipe.readyInMinutes) + " \(names[2])"
        
        let attributedString = NSMutableAttributedString(string: recipeString + ingidientsString + caloriesString + timeString)
        attributedString.addAttribute(.font, value: UIFont.preferredFont(forTextStyle: .headline), range: NSMakeRange(0, recipeString.count))
        attributedString.addAttribute(.font, value: UIFont.preferredFont(forTextStyle: .footnote), range: NSMakeRange(recipeString.count + ingidientsString.count - 11, 10))
        attributedString.addAttribute(.font, value: UIFont.preferredFont(forTextStyle: .footnote), range: NSMakeRange(recipeString.count + ingidientsString.count + caloriesString.count - 9, 8))
        attributedString.addAttribute(.font, value: UIFont.preferredFont(forTextStyle: .footnote), range: NSMakeRange(recipeString.count + ingidientsString.count + caloriesString.count + timeString.count - 7, 7))
        recipeLabel.attributedText = attributedString
        
        likeButton.setTitle(" \(recipe.aggregateLikes)", for: .normal)
        networkClient.getImageFrom(stringUrl: recipe.image) { [weak self] image in
            self?.searchImageView.configure(image: image)
        }
    }
}

// MARK: - Private func

private extension SearchTableViewMiniCell {
    @objc func favoriteButtonPressed(_ sender: UIButton!) {
        if sender.image(for: .normal) == UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(font: .preferredFont(forTextStyle: .headline))) {
            sender.setImage(UIImage(systemName: "heart.fill", withConfiguration: UIImage.SymbolConfiguration(font: .preferredFont(forTextStyle: .headline))), for: .normal)
        } else {
            sender.setImage(UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(font: .preferredFont(forTextStyle: .headline))), for: .normal)
        }
        
    }
    
    func setAttributedString(_ numbers: String, _ text: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: numbers + " " + text)
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.preferredFont(forTextStyle: .headline), range: NSMakeRange(0, numbers.count))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.label, range: NSMakeRange(0, numbers.count))
        
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.preferredFont(forTextStyle: .footnote), range: NSMakeRange(numbers.count + 1, text.count))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.label, range: NSMakeRange(numbers.count + 1, text.count))
        
        return attributedString
    }
    
    private func setup() {
        contentView.addSubview(searchImageView)
        NSLayoutConstraint.activate([
            searchImageView.heightAnchor.constraint(equalToConstant: 100),
            searchImageView.widthAnchor.constraint(equalToConstant: 100),
            searchImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Theme.topOffset),
            searchImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Theme.leftOffset / 2),
            searchImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -Theme.topOffset),
        ])
        
        contentView.addSubview(recipeLabel)
        NSLayoutConstraint.activate([
            recipeLabel.topAnchor.constraint(equalTo: searchImageView.topAnchor),
            recipeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Theme.leftOffset / 2),
            recipeLabel.bottomAnchor.constraint(equalTo: searchImageView.bottomAnchor),
            recipeLabel.leadingAnchor.constraint(equalTo: searchImageView.trailingAnchor, constant:  Theme.leftOffset / 2)
        ])

        contentView.addSubview(likeButton)
        NSLayoutConstraint.activate([
            likeButton.bottomAnchor.constraint(equalTo: recipeLabel.bottomAnchor),
            likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Theme.leftOffset / 2),
        ])
    }
}
