//
//  RecipesModelFromDataConverter.swift
//  CookBook
//
//  Created by SERGEY SHLYAKHIN on 30.11.2022.
//

import Foundation

struct RecipesModelFromDataConverter {
    func convert(data: RecipesData.Recipe?) -> RecipesModel.Recipe? {
        guard
            let id = data?.id,
            let title = data?.title,
            let readyInMinutes = data?.readyInMinutes,
            let servings = data?.servings,
            let image = data?.image,
            let instructions = convertInstructions(data: data?.analyzedInstructions),
            let spoonacularSourceUrl = data?.spoonacularSourceUrl
        else {
            return nil
        }
        return .init(
            id: id,
            title: title,
            readyInMinutes: readyInMinutes,
            servings: servings,
            image: image,
            instructions: instructions,
            spoonacularSourceUrl: spoonacularSourceUrl
        )
    }
    
    private func convertInstructions(data: [RecipesData.Instruction]?) -> [RecipesModel.Instruction]? {
        guard
            let data = data,
            !data.isEmpty
        else {
            return nil
        }
        
        var instructions: [RecipesModel.Instruction] = []
        
        for item in data {
            if let name = item.name,
               !name.isEmpty {
                instructions.append(.init(step: name, seconds: 0))
            }
            if let steps = item.steps,
               !steps.isEmpty {
                for step in steps {
                    if let name = step.step,
                       !name.isEmpty,
                       let length = step.length,
                       let number = length.number,
                       let unit = length.unit {
                        let seconds = unit == "minutes" ? number * 60 : number
                        instructions.append(.init(step: name, seconds: seconds))
                    }
                }
            }
        }
        
        guard !instructions.isEmpty else { return nil }
        return instructions
    }
}
