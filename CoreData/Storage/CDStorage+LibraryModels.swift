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

                let series = book.series
                    .map {
                        Series(id: $0.id, name: $0.name)
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
                    publisher: publisher,
                    series: series
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

        try checkAuthorPublisherRules()
    }

    func deleteBook(_ book: Book) throws {
        try checkWhetherDeleteAuthor(book)

        try checkWhetherDeletePublisher(book)

        try self.deleteBook(id: book.id)
    }

    func checkAuthorPublisherRules() throws {
        let allAuthors = self.fetchAuthors()

        for author in allAuthors {
            if author.books.isEmpty {
                try self.deleteAuthor(author.id)
            }
        }

        let allPublishers = self.fetchPublishers()

        for publisher in allPublishers {
            if publisher.books.isEmpty {
                try self.deletePublisher(publisher.id)
            }
        }
    }

    func checkWhetherDeleteAuthor(_ book: Book) throws {
        let bookAuthors = try book.authors
            .map {
                try self.fetchAuthor(id: $0.id)
            }

        for author in bookAuthors {
            if author.books.count == 1 {
                try self.deleteAuthor(author.id)
            }
        }
    }

    func checkWhetherDeletePublisher(_ book: Book) throws {
        guard let bookPublisher = book.publisher else {
            return
        }

        let publisher = try fetchPublisher(id: bookPublisher.id)

        if publisher.books.count == 1 {
            try deletePublisher(publisher.id)
        }
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

    func getPublishers() -> [Publisher] {
        self.fetchPublishers()
            .map {
                Publisher(id: $0.id, name: $0.name)
            }
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

    func getSeries() -> [Series] {
        self.fetchSeries()
            .map {
                Series(id: $0.id, name: $0.name)
            }
    }

    private func saveThenReturnSeries(_ series: Series) -> CDSeries {
        self.saveSeries(
            id: series.id,
            name: series.name
        )
    }

    func fetchOrSaveSeries(_ series: Series?) throws -> CDSeries? {
        guard let series else {
            return nil
        }

        do {
            return try fetchSeries(id: series.id)
        } catch CoreDataError.seriesNotFound {
            return self.saveThenReturnSeries(series)
        }
    }

    func deleteSeries(_ id: UUID) throws {
        try self.deleteSeries(id: id)
    }

}
