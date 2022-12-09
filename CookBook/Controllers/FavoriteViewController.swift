//
//  FavoriteViewController.swift
//  CookBook
//
//  Created by SERGEY SHLYAKHIN on 06.12.2022.
//

import UIKit

final class FavoriteViewController: UIViewController {
    var tableView = UITableView()
    let dataSource: FavoriteRecipesDataSource = .init(favoriteRecipes: FavoriteRecipesStorage.shared.getFavoriteRecipes())

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        applyStyle()
        applyLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataSource.favoriteRecipes = FavoriteRecipesStorage.shared.getFavoriteRecipes()
        tableView.reloadData()
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

private extension FavoriteViewController {

    func setup() {
        setupTableView()
    }

    func applyStyle() {
        title = "Favorite"
        view.backgroundColor = Theme.appColor
    }

    func applyLayout() {
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = dataSource
        
        tableView.register(SearchTableViewMiniCell.self, forCellReuseIdentifier: SearchTableViewMiniCell.reuseID)
        tableView.reloadData()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
}

// MARK: - UITableViewDelegate
extension FavoriteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recipe = convert(dataSource.favoriteRecipes[indexPath.row])
        let vc = DetailViewController(with: recipe)
        navigationController?.pushViewController(vc, animated: true)
        
        func convert(_ recipe: SearchModel) -> DetailRecipeModel {
            .init(
                id: recipe.id,
                title: recipe.title,
                aggregateLikes: recipe.aggregateLikes,
                readyInMinutes: recipe.readyInMinutes,
                servings: 3,
                image: recipe.image,
                calories: recipe.calories,
                ingredients: [
                    .init(image: "butter-sliced.jpg", original: "2 tablespoon butter")
                ],
                steps: [
                    .init(step: "test", minutes: 12)
                ]
            )
        }
    }
}
