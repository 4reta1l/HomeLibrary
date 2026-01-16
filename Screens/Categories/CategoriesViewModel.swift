//
//  CategoriesViewModel.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 16/01/2026.
//

import Foundation

@Observable
final class CategoriesViewModel {

    private let categoriesStorage: CategoriesStorage

    var categories: [Category]

    init(categoriesStorage: CategoriesStorage = CDStorage.shared) {
        self.categoriesStorage = categoriesStorage
        self.categories = self.categoriesStorage.getCategories()
    }
}
