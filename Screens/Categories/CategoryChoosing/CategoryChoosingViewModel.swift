//
//  CategoryChoosingViewModel.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 16/01/2026.
//

import Foundation

@Observable
final class CategoryChoosingViewModel {

    private var categoriesStorage: CategoriesStorage
    var categories: [Category]
    var selectedCategory: Category

    init(categoriesStorage: CategoriesStorage = CDStorage.shared, selectedCategory: Category) {
        self.categoriesStorage = categoriesStorage
        self.selectedCategory = selectedCategory
        self.categories = categoriesStorage.getCategories()
    }

    func reloadCategories() {
        self.categories = categoriesStorage.getCategories()
    }

    func addCategory(_ category: Category) {
        self.categoriesStorage.addCategory(category)

        selectedCategory = category
        reloadCategories()
    }
}
