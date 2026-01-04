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
            .map { book in
                let genres = book.genres
                    .map {
                        Genre(name: $0.name)
                    }

                return Book(
                    id: book.id,
                    title: book.title,
                    author: book.author,
                    genres: genres,
                    notes: book.notes,
                    status: Status(rawValue: book.rawStatus) ?? .unread,
                    isbn: book.isbn,
                    pages: book.pages.map { Int(truncating: $0) },
                    year: book.year.map { Int(truncating: $0) }
                )
            }
        return books
    }

    func addBook(_ book: Book) throws {
        let genres = try book.genres
            .map {
                try self.fetchGenre(name: $0.name)
            }

        try self.saveBook(
            title: book.title,
            author: book.author,
            notes: book.notes,
            rawStatus: book.status.rawValue,
            isbn: book.isbn,
            pages: book.pages.map { NSNumber(value: $0) },
            year: book.year.map { NSNumber(value: $0) },
            genres: genres
        )
    }

    func updateBook(_ book: Book) throws {
        let genres = try book.genres
            .map {
                try self.fetchGenre(name: $0.name)
            }

        try self.updateBook(
            id: book.id,
            title: book.title,
            author: book.author,
            notes: book.notes,
            rawStatus: book.status.rawValue,
            isbn: book.isbn,
            pages: book.pages.map { NSNumber(value: $0) },
            year: book.year.map { NSNumber(value: $0) },
            genres: genres
        )
    }

    func deleteBook(_ id: UUID) throws {
        try self.deleteBook(id: id)
    }

    func getGenres() -> [Genre] {
        let genres = self.fetchGenres()
            .map {
                Genre(name: $0.name)
        }

        return genres
    }
}
