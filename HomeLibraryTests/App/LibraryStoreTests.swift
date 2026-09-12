//
//  LibraryStoreTests.swift
//  HomeLibraryTests
//

import Testing
import Foundation
@testable import HomeLibrary

struct LibraryStoreTests {

    @Test func addBook_persistsAndReloadsBooks() throws {
        let booksStorage = FakeBooksStorage()
        let store = makeStore(booksStorage: booksStorage)
        let book = makeBook(title: "Dune")

        try store.addBook(book)

        #expect(booksStorage.addedBooks == [book])
        #expect(store.books == [book])
    }

    @Test func updateBook_persistsAndReloadsBooks() throws {
        let book = makeBook(title: "Dune")
        let booksStorage = FakeBooksStorage(books: [book])
        let store = makeStore(booksStorage: booksStorage)
        let updatedBook = makeBook(id: book.id, title: "Dune Messiah")

        try store.updateBook(updatedBook)

        #expect(booksStorage.updatedBooks == [updatedBook])
        #expect(store.books == [updatedBook])
    }

    @Test func deleteBook_removesFromReloadedBooks() throws {
        let book = makeBook(title: "Dune")
        let booksStorage = FakeBooksStorage(books: [book])
        let store = makeStore(booksStorage: booksStorage)

        try store.deleteBook(book)

        #expect(booksStorage.deletedBooks == [book])
        #expect(store.books.isEmpty)
    }

    private func makeStore(booksStorage: FakeBooksStorage) -> LibraryStore {
        LibraryStore(
            booksStorage: booksStorage,
            authorsStorage: FakeAuthorsStorage(),
            genresStorage: FakeGenresStorage(),
            categoriesStorage: FakeCategoriesStorage(),
            importer: FakeLibraryImporting()
        )
    }

    private func makeBook(
        id: UUID = UUID(),
        title: String,
        category: HomeLibrary.Category = HomeLibrary.Category(name: "Owned")
    ) -> Book {
        Book(
            id: id,
            title: title,
            authors: [],
            genres: [],
            status: .unread,
            series: nil,
            category: category
        )
    }
}
