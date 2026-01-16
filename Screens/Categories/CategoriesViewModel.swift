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

    //TODO: Update when new book added
    func amountForSpecificCategory(_ category: Category) -> String {
        do {
            let cdCategoryBooks = try CDStorage.shared.fetchCategoryByName(name: category.name).books

            if cdCategoryBooks?.count == 1 {
                return "1 book"
            } else {
                return "\(cdCategoryBooks?.count ?? 0) books"
            }
        } catch {
            print("Error fetching category by name: \(error)")
            return "0 books"
        }
    }

    func reloadData() {
        self.categories = self.categoriesStorage.getCategories()
    }
}
