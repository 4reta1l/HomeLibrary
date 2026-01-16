//
//  CDStorage+Category.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 16/01/2026.
//

import Foundation
import CoreData

extension CDStorage {

    func fetchCategories() -> [CDCategory] {
        let request = CDCategory.fetchRequest()

        do {
            return try container.viewContext.fetch(request)
        } catch {
            print("Error fetching series: \(error)")
            return []
        }
    }

    func fetchCategoryByName(name: String) throws -> CDCategory {
        let request = CDCategory.fetchRequest().filteredByName(name)

        let results = try container.viewContext.fetch(request)
        guard let category = results.first else {
            throw CoreDataError.categoryNotFound
        }

        return category
    }

    func saveCategory(id: UUID, name: String) {
        let newCategory = CDCategory(context: container.viewContext)
        newCategory.id = id
        newCategory.name = name

        saveData()
    }

    func updateCategory(id: UUID, name: String) throws {
        let request = CDCategory.fetchRequest().filteredById(id)

        let results = try container.viewContext.fetch(request)
        if let categoryToUpdate = results.first {
            categoryToUpdate.id = id
            categoryToUpdate.name = name
        }

        saveData()
    }

    func saveCategoryThenReturn(id: UUID, name: String) -> CDCategory {
        let newCategory = CDCategory(context: container.viewContext)
        newCategory.id = id
        newCategory.name = name

        saveData()

        return newCategory
    }
}
