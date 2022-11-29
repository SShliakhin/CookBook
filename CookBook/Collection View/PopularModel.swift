//
//  PopularModel.swift
//  CookBook
//
//  Created by Alexander Altman on 30.11.2022.
//

import UIKit

struct PopularRecipe {
    var image: UIImage
    var name: String
    
    
    static func fetchRecipes() -> [PopularRecipe] {
        let firstItem = PopularRecipe(image: UIImage(named: "Cookbook_logo_trans")!, name: "First Recipe")
        let secondItem = PopularRecipe(image: UIImage(named: "Cookbook_logo_trans")!, name: "Second Recipe")
        let thirdItem = PopularRecipe(image: UIImage(named: "Cookbook_logo_trans")!, name: "Third Recipe")
        let fourthItem = PopularRecipe(image: UIImage(named: "Cookbook_logo_trans")!, name: "Fourth Recipe")
        let fifthItem = PopularRecipe(image: UIImage(named: "Cookbook_logo_trans")!, name: "Fifth Recipe")
        let sixthItem = PopularRecipe(image: UIImage(named: "Cookbook_logo_trans")!, name: "Sixth Recipe")
        return [firstItem, secondItem, thirdItem, firstItem, fifthItem, sixthItem]
    }
}
