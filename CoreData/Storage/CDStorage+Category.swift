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

    // Note: unlike saveCategoryThenReturn, this isn't on the book-save path (it backs the
    // standalone "add category" screens), so it isn't part of this throws chain yet and
    // still swallows a save failure rather than surfacing it to those screens.
    func saveCategory(id: UUID, name: String) {
        let newCategory = CDCategory(context: container.viewContext)
        newCategory.id = id
        newCategory.name = name

        try? saveData()
    }

    func updateCategory(id: UUID, name: String) throws {
        let request = CDCategory.fetchRequest().filteredById(id)

        let results = try container.viewContext.fetch(request)
        if let categoryToUpdate = results.first {
            categoryToUpdate.id = id
            categoryToUpdate.name = name

            try saveData()
        }
    }

    func saveCategoryThenReturn(id: UUID, name: String) throws -> CDCategory {
        let newCategory = CDCategory(context: container.viewContext)
        newCategory.id = id
        newCategory.name = name

        try saveData()

        return newCategory
    }

    func fetchOrCreateCategory(
        name: String,
        context: NSManagedObjectContext
    ) -> CDCategory {
        let request = CDCategory.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", name)

        if let existing = try? context.fetch(request).first {
            return existing
        }

        let category = CDCategory(context: context)
        category.id = UUID()
        category.name = name
        return category
    }
}
