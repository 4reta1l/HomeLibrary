//
//  BookStorageTests.swift
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
}
