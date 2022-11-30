//
//  DetailScreenHeaderView.swift
//  CookBook
//
//  Created by Анастасия Бегинина on 30.11.2022.
//

import UIKit

// MARK: - Header for DetailView table
class DetailScreenHeader: UITableViewHeaderFooterView{
    // MARK: - Properties
    static let identifier = "DetailHeader"
    
    // MARK: - Initializers
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(imageView)
        contentView.addSubview(recipeName)

    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: Functionality
    func configureRecipeName(newRecipeName: String){
        recipeName.text = newRecipeName
    }
    
    // MARK: - UI elements
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "test_recipe_image")
        return imageView
    }()
    
    private let recipeName: UILabel = {
        let label = UILabel()
        label.text = "Simple salad"
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.textAlignment = .left
        return label
    }()
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        recipeName.sizeToFit()
        imageView.frame = CGRect(x: 0, y: 0,
                                 width: contentView.frame.size.width,
                                 height: contentView.frame.size.height)
        recipeName.frame = CGRect(x: contentView.frame.minX + 10,
                             y: imageView.frame.maxY - recipeName.frame.height,
                             width: recipeName.frame.size.width,
                             height: recipeName.frame.size.height)
    }
}
