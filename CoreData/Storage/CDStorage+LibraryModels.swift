//
//  CDStorage+LibraryModels.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 26/12/2025.
//

import Foundation

extension CDStorage {

    func getBooks() -> [Book] {
        let books = self.fetchBooks()
            .map {
                return Book(
                    id: $0.id,
                    title: $0.title,
                    author: $0.author,
                    genre: Genre.general,
                    year: Int($0.year),
                    notes: $0.notes,
                    status: Status(rawValue: $0.rawStatus) ?? .unread,
                    isbn: $0.isbn,
                    pages: Int($0.pages)
                )
            }
        return books
    }

    func addBook(_ book: Book) {
        self.saveBook(
            title: book.title,
            author: book.author,
            year: Int32(book.year),
            notes: book.notes,
            rawStatus: book.status.rawValue,
            isbn: book.isbn,
            pages: Int32(book.pages)
        )
    }
}
