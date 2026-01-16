//
//  LibraryStore.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 16/01/2026.
//

import Foundation

@Observable
final class LibraryStore {

    private let storage = CDStorage.shared

    var books: [Book] = []
    var categories: [Category] = []
    var authors: [Author] = []
    var genres: [Genre] = []

    init() {
        reloadAll()
    }

    func reloadAll() {
        self.books = self.storage.getBooks().reversed()
        self.categories = self.storage.getCategories()
        self.authors = storage.getAuthors()
        self.genres = storage.getGenres()
    }

    func addBook(_ book: Book) throws {
        try self.storage.addBook(book)
        reloadAll()
    }

    func updateBook(_ book: Book) throws {
        try self.storage.updateBook(book)
        reloadAll()
    }

    func deleteBook(_ book: Book) throws {
        try self.storage.deleteBook(book)
        reloadAll()
    }

    func addCategory(_ category: Category) {
        self.storage.addCategory(category)
        reloadAll()
    }

    func displayBooksCountForCategory(_ category: Category) -> String {
        let filteredBooksCount = books.filter { $0.category == category }.count
        if filteredBooksCount == 1 {
            return "1 book"
        } else {
            return "\(filteredBooksCount) books"
        }
    }
}
