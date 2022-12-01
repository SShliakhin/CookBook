//
//  DetailViewController.swift
//  CookBook
//
//  Created by Анастасия Бегинина on 30.11.2022.
//

import UIKit


final class DetailViewController: UIViewController {
    // MARK: - Properties
    private let ingredients = "cucumber 1 pc \n tomato 1 pc \n oil 1 tbsp" //for test
    var addedToFavourites = false

    // MARK: - UI elements
    private let recipeImageView: UIImageView = {
        let image = UIImage(named: "test_recipe_image")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let shadowImageView: UIImageView = {
        let image = UIImage(named: "shadow")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "detailCell")
        return table
    }()
    
    private let recipeNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Simple salad"
        label.textColor = .white
        label.numberOfLines = 1
        label.minimumScaleFactor = 0.5
        label.font = UIFont.systemFont(ofSize: 27, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let detailStackView: UIStackView = {
        // MARK: - Properties for stack view
        
        typealias Item = (name: String, value: Int)
        let items: [Item] = [
          Item(name: "ing", value: 3),
          Item(name: "kcal", value: 350),
          Item(name: "min", value: 10),
        ]
        
        let valueFormatter = NumberFormatter()
        valueFormatter.numberStyle = .decimal
        
        // MARK: - Custom styles for stack view
        let valueStyle: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 23), NSAttributedString.Key.foregroundColor: UIColor.white]
        let nameStyle: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .thin), NSAttributedString.Key.foregroundColor: UIColor.white]
        
        // MARK: - StackView build
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        
        func buildSeparatorForStackView(){
            let separator = UIView()
            separator.widthAnchor.constraint(equalToConstant: 0.5).isActive = true
            separator.backgroundColor = .white
            stackView.addArrangedSubview(separator)
            separator.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.4).isActive = true
        }
        
        func buildLabelForStackView(for item: Item){
            let totalText = NSMutableAttributedString()
            let valueString = valueFormatter.string(for: item.value)!
            totalText.append(NSAttributedString(string: valueString + " ", attributes: valueStyle))
            totalText.append(NSAttributedString(string: item.name, attributes: nameStyle))
            let label = UILabel()
            label.attributedText = totalText
            label.textAlignment = .center
            label.numberOfLines = 0
            stackView.addArrangedSubview(label)

            if let firstLabel = stackView.arrangedSubviews.first as? UILabel {
                label.widthAnchor.constraint(equalTo: firstLabel.widthAnchor).isActive = true
            }
        }
        
        for item in items {
            if stackView.arrangedSubviews.count > 0 {
                buildSeparatorForStackView()
            }
            buildLabelForStackView(for: item)
        }
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var addToFavouritesButton: UIButton = {
        let button = UIButton()
        
        let imageName = (addedToFavourites) ? "heart.fill" : "heart"
        
        button.setImage(UIImage(systemName: imageName, withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .medium)), for: .normal)
        button.tintColor = .white
        
        button.addTarget(self, action: #selector(addToFavourites), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        setupHierarchy()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    // MARK: - Setups
    private func setupHierarchy() {
        view.addSubview(recipeImageView)
        setupRecipeImageView()
        view.addSubview(shadowImageView)
        setupShadowImageView()
        view.addSubview(recipeNameLabel)
        setupRecipeNameLabel()
        view.addSubview(detailStackView)
        setupDetailStackView()
        view.addSubview(addToFavouritesButton)
        setupAddToFavouritesButton()
        //view.addSubview(tableView)
        //setupRecipeTableView()
    }
    
    private func setupRecipeTableView(){
        NSLayoutConstraint.activate([
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupRecipeImageView(){
        NSLayoutConstraint.activate([
            recipeImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            recipeImageView.widthAnchor.constraint(equalToConstant: view.frame.width),
            recipeImageView.heightAnchor.constraint(equalToConstant: 320)
        ])
    }
    
    private func setupShadowImageView(){
        NSLayoutConstraint.activate([
            shadowImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            shadowImageView.bottomAnchor.constraint(equalTo: recipeImageView.bottomAnchor)
        ])
    }
    
    private func setupRecipeNameLabel(){
        NSLayoutConstraint.activate([
            recipeNameLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40),
            recipeNameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 220),
            recipeNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25)
        ])
    }
    
    private func setupDetailStackView(){
        NSLayoutConstraint.activate([
            detailStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            detailStackView.bottomAnchor.constraint(equalTo: recipeImageView.bottomAnchor),
            detailStackView.widthAnchor.constraint(equalTo: recipeNameLabel.widthAnchor),
            detailStackView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    private func setupAddToFavouritesButton(){
        NSLayoutConstraint.activate([
            addToFavouritesButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addToFavouritesButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
        ])
    }
    
    //MARK: - Actions
    @objc private func addToFavourites() {
        addedToFavourites = !addedToFavourites
        let imageName = (addedToFavourites) ? "heart.fill" : "heart"
        addToFavouritesButton.setImage(UIImage(systemName: imageName, withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .medium)), for: .normal)
    }
}

// MARK: - UITableView Data Source/Delegate
extension DetailViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath)
        cell.textLabel?.text = ingredients
        
        return cell
    }
}

extension DetailViewController: UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
