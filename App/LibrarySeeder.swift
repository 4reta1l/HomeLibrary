//
//  LibrarySeeder.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 28/08/2026.
//

import Foundation

struct LibrarySeeder {
    let genresStorage: GenresStorage
    let categoriesStorage: CategoriesStorage

    func seedIfNeeded() {
        if genresStorage.getGenres().isEmpty {
            DefaultGenres.allCases.forEach {
                genresStorage.addGenre(name: $0.displayString)
            }
        }
        if categoriesStorage.getCategories().isEmpty {
            DefaultCategories.allCases.forEach {
                categoriesStorage.addCategory(Category(name: $0.name))
            }
        }
    }
}
