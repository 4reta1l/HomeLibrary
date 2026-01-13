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
                let authors = book.authors
                    .map {
                        Author(id: $0.id, displayName: $0.displayName)
                    }

                let genres = book.genres
                    .map {
                        Genre(name: $0.name)
                    }

                let publisher = book.publisher
                    .map {
                        Publisher(id: $0.id, name: $0.name)
                    }

                return Book(
                    id: book.id,
                    title: book.title,
                    authors: authors,
                    genres: genres,
                    notes: book.notes,
                    status: Status(rawValue: book.rawStatus) ?? .unread,
                    isbn: book.isbn,
                    pages: book.pages.map { Int(truncating: $0) },
                    year: book.year.map { Int(truncating: $0) },
                    publisher: publisher
                )
            }
        return books
    }

    func addBook(_ book: Book) throws {
        let authors = try book.authors
            .map {
                try self.fetchOrSaveAuthor($0)
            }

        let genres = try book.genres
            .map {
                try self.fetchGenre(name: $0.name)
            }

        let publisher = try fetchOrSavePublisher(book.publisher)


        try self.saveBook(
            title: book.title,
            authors: Set(authors),
            notes: book.notes,
            rawStatus: book.status.rawValue,
            isbn: book.isbn,
            pages: book.pages.map { NSNumber(value: $0) },
            year: book.year.map { NSNumber(value: $0) },
            genres: Set(genres),
            publisher: publisher
        )
    }

    func updateBook(_ book: Book) throws {
        let authors = try book.authors
            .map {
                try self.fetchOrSaveAuthor($0)
            }

        let genres = try book.genres
            .map {
                try self.fetchGenre(name: $0.name)
            }

        let publisher = try fetchOrSavePublisher(book.publisher)

        try self.updateBook(
            id: book.id,
            title: book.title,
            authors: Set(authors),
            notes: book.notes,
            rawStatus: book.status.rawValue,
            isbn: book.isbn,
            pages: book.pages.map { NSNumber(value: $0) },
            year: book.year.map { NSNumber(value: $0) },
            genres: Set(genres),
            publisher: publisher
        )

        let allAuthors = self.fetchAuthors()

        for author in allAuthors {
            if author.books.isEmpty {
                try self.deleteAuthor(author.id)
            }
        }
    }

    func deleteBook(_ book: Book) throws {
        let bookAuthors = try book.authors
            .map {
                try self.fetchOrSaveAuthor($0)
            }

        for author in bookAuthors {
            if author.books.count == 1 {
                try self.deleteAuthor(author.id)
            }
        }

        try self.deleteBook(id: book.id)
    }

    func getGenres() -> [Genre] {
        let genres = self.fetchGenres()
            .map {
                Genre(name: $0.name)
        }

        return genres
    }

    func addGenre(name: String) {
        self.saveGenre(name: name)
    }

    func getAuthors() -> [Author] {
        self.fetchAuthors()
            .map {
                Author(id: $0.id, displayName: $0.displayName)
            }
    }

    private func saveThenReturnAuthor(_ author: Author) -> CDAuthor {
        self.saveAuthor(
            id: author.id,
            displayName: author.displayName
        )
    }

    func fetchOrSaveAuthor(_ author: Author) throws -> CDAuthor {
        do {
            return try fetchAuthor(id: author.id)
        } catch CoreDataError.authorNotFound {
            return self.saveThenReturnAuthor(author)
        }
    }

    func deleteAuthor(_ id: UUID) throws {
        try self.deleteAuthor(id: id)
    }

    private func saveThenReturnPublisher(_ publisher: Publisher) -> CDPublisher {
        self.savePublisher(
            id: publisher.id,
            name: publisher.name
        )
    }

    func fetchOrSavePublisher(_ publisher: Publisher?) throws -> CDPublisher? {
        guard let publisher else {
            return nil
        }

        do {
            return try fetchPublisher(id: publisher.id)
        } catch CoreDataError.publisherNotFound {
            return self.saveThenReturnPublisher(publisher)
        }
    }

    func deletePublisher(_ id: UUID) throws {
        try self.deletePublisher(id: id)
    }
}
