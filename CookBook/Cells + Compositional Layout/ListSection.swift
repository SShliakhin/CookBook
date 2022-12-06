//
//  ListSection.swift
//  CookBook
//
//  Created by Alexander Altman on 30.11.2022.
//

import Foundation

enum ListSection {
    case popular([ListItem])
    case random([ListItem])
    
    // Define sections
    var items: [ListItem] {
        switch self {
        case .popular(let items),
                .random(let items):
            return items
        }
    }
    // Count of items in Sections
    var count: Int {
        items.count
    }
    
    // Sections Headers
    var title: String {
        switch self {
        case .popular(_):
            return "Popular Recipes"
        case .random(_):
            return "Random Recipes"
            
        }
    }
}
