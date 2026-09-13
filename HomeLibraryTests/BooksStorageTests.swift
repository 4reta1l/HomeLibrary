//
//  BooksStorageTests.swift
//  HomeLibraryTests
//
//  Created by Maksym Pyvovarov on 01/09/2026.
//

import Testing
import Foundation
@testable import HomeLibrary

struct BooksStorageTests {

    @Test("A saved book keeps the id it was given")
    func addBookPreservesID() throws {
        let sut = CDStorage(inMemory: true)
        let book = Book(
            id: UUID(),
            title: "Dune",
            authors: [],
            genres: [],
            status: .unread,
            series: nil,
            category: .default
        )

        try sut.addBook(book)

        #expect(sut.getBooks().contains { $0.id == book.id })
    }

    @Test("Saving a book with a genre unknown to storage creates the genre instead of failing")
    func addBookWithNewGenrePersistsGenre() throws {
        let sut = CDStorage(inMemory: true)
        let book = Book(
            id: UUID(),
            title: "Dune",
            authors: [],
            genres: [Genre(name: "Sci-Fi")],
            status: .unread,
            series: nil,
            category: .default
        )

        try sut.addBook(book)

        #expect(sut.getBooks().first?.genres == [Genre(name: "Sci-Fi")])
        #expect(sut.getGenres().contains(Genre(name: "Sci-Fi")))
    }

    @Test("A Core Data validation failure is thrown by saveData, not swallowed")
    func saveDataThrowsOnValidationFailure() {
        let sut = CDStorage(inMemory: true)
        // CDBook.title is a required attribute; leaving it unset makes the save fail
        // validation, which is what saveData used to catch, print, and discard.
        _ = CDBook(context: sut.container.viewContext)

        #expect(throws: (any Error).self) {
            try sut.saveData()
        }
    }

    @Test("A failed save doesn't poison later saves")
    func failedSaveLeavesContextUsable() throws {
        let sut = CDStorage(inMemory: true)
        // CDBook.title is a required attribute; leaving it unset makes the save fail
        // validation. saveData must roll the failed insert back so it doesn't keep
        // failing validation on every save after it.
        _ = CDBook(context: sut.container.viewContext)

        #expect(throws: (any Error).self) {
            try sut.saveData()
        }

        sut.addCategory(Category(name: "Owned"))
        #expect(sut.getCategories().count == 1)
    }
}
