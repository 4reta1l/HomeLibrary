//
//  LibraryStore.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 16/01/2026.
//

import Foundation

@Observable
final class LibraryStore {

    private let importer: LibraryImporting

    // MARK: - Dependencies

    private let booksStorage: BooksStorage
    private let authorsStorage: AuthorsStorage
    private let genresStorage: GenresStorage
    private let categoriesStorage: CategoriesStorage

    // MARK: - State

    private(set) var books: [Book] = []
    private(set) var categories: [Category] = []
    private(set) var authors: [Author] = []
    private(set) var genres: [Genre] = []

    // MARK: - Init

    init(
        booksStorage: BooksStorage,
        authorsStorage: AuthorsStorage,
        genresStorage: GenresStorage,
        categoriesStorage: CategoriesStorage,
        importer: LibraryImporting
    ) {
        self.booksStorage = booksStorage
        self.authorsStorage = authorsStorage
        self.genresStorage = genresStorage
        self.categoriesStorage = categoriesStorage
        self.importer = importer
        reloadAll()
    }

    // MARK: - Loading

    func reloadAll() {
        books = booksStorage.getBooks().reversed()
        categories = categoriesStorage.getCategories()
        authors = authorsStorage.getAuthors()
        genres = genresStorage.getGenres()
    }

    // MARK: - Books

    func addBook(_ book: Book) throws {
        try booksStorage.addBook(book)
        reloadAll()
    }

    func updateBook(_ book: Book) throws {
        try booksStorage.updateBook(book)
        reloadAll()
    }

    func deleteBook(_ book: Book) throws {
        try booksStorage.deleteBook(book)
        reloadAll()
    }

    // MARK: - Categories

    func addCategory(_ category: Category) {
        categoriesStorage.addCategory(category)
        reloadAll()
    }

    // MARK: - Presentation
    // Belongs in the view layer — moves out in Phase 3.4.

    func displayBooksCountForCategory(_ category: Category) -> String {
        let filteredBooksCount = books.filter { $0.category == category }.count
        return filteredBooksCount == 1 ? "1 book" : "\(filteredBooksCount) books"
    }

    // MARK: - Import

    func importBooks(from url: URL) throws {
        try importer.importBooks(from: url)
        reloadAll()
    }
}
