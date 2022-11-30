//
//  RecipesModel.swift
//  CookBook
//
//  Created by SERGEY SHLYAKHIN on 30.11.2022.
//

import Foundation

struct RecipesModel {
    let recipes: [Recipe]
    
    struct Recipe {
        let id: Int
        let title: String
        let readyInMinutes: Int
        let servings: Int
        let image: String
        let instructions: [Instruction]
        let spoonacularSourceUrl: String
    }
    
    struct Instruction {
        let step: String
        let seconds: Int
    }
}
