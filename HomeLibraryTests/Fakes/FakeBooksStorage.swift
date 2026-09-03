//
//  FakeBooksStorage.swift
//  HomeLibraryTests
//

@testable import HomeLibrary

final class FakeBooksStorage: BooksStorage {

    private(set) var books: [Book]
    private(set) var addedBooks: [Book] = []
    private(set) var updatedBooks: [Book] = []
    private(set) var deletedBooks: [Book] = []

    init(books: [Book] = []) {
        self.books = books
    }

    func getBooks() -> [Book] {
        books
    }

    func addBook(_ book: Book) throws {
        addedBooks.append(book)
        books.append(book)
    }

    func updateBook(_ book: Book) throws {
        updatedBooks.append(book)
        if let index = books.firstIndex(where: { $0.id == book.id }) {
            books[index] = book
        }
    }

    func deleteBook(_ book: Book) throws {
        deletedBooks.append(book)
        books.removeAll { $0.id == book.id }
    }
}
