//
//  FakeCategoriesStorage.swift
//  HomeLibraryTests
//

@testable import HomeLibrary

enum FakeStorageError: Error {
    case notFound
}

final class FakeCategoriesStorage: CategoriesStorage {

    private(set) var categories: [HomeLibrary.Category]

    init(categories: [HomeLibrary.Category] = []) {
        self.categories = categories
    }

    func getCategories() -> [HomeLibrary.Category] {
        categories
    }

    func getCategoryByName(_ name: String) throws -> HomeLibrary.Category {
        guard let category = categories.first(where: { $0.name == name }) else {
            throw FakeStorageError.notFound
        }
        return category
    }

    func addCategory(_ category: HomeLibrary.Category) {
        categories.append(category)
    }

    func editCategory(_ category: HomeLibrary.Category) throws {
        guard let index = categories.firstIndex(where: { $0.id == category.id }) else {
            throw FakeStorageError.notFound
        }
        categories[index] = category
    }
}
