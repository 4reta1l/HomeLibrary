//
//  EditBookViewModel.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 17/12/2025.
//

import Foundation

//TODO: Protocol
@Observable
final class EditBookViewModel {

    private let booksStorage: BooksStorage
    private var bookId: UUID?
    var bookTitle: String
    var bookAuthor: String
    var bookGenre: Genre
    var bookYear: Int
    var bookPages: String
    var bookStatus: Status
    var bookNotes: String
    var bookIsbn: String

    init(
        booksStorage: BooksStorage = CDStorage.shared,
        state: EditBookView.ViewState
    ) {
        self.booksStorage = booksStorage

        switch state {
        case .addBook:
            bookTitle = ""
            bookAuthor = ""
            bookGenre = .general
            bookYear = Date().year
            bookPages = ""
            bookStatus = .unread
            bookNotes = ""
            bookIsbn = ""

        case .editBook(let book):
            bookId = book.id
            bookTitle = book.title
            bookAuthor = book.author
            bookGenre = book.genre
            bookYear = book.year
            bookPages = "\(book.pages)"
            bookStatus = book.status
            bookNotes = book.notes
            bookIsbn = book.isbn
        }
    }

    let yearsArray = Array(1440...Date().year)

    func addBook() {
        let pages = Int(bookPages) ?? 0

        let newBook = Book(
            title: bookTitle,
            author: bookAuthor,
            genre: bookGenre,
            year: bookYear,
            notes: bookNotes,
            status: bookStatus,
            isbn: bookIsbn,
            pages: pages
        )

        do {
            try self.booksStorage.addBook(newBook)
        } catch {
            print("Failed to add book: \(error)")
        }
    }

    func updateBook() {
        let id = bookId ?? UUID()
        let pages = Int(bookPages) ?? 0

        let updatingBook = Book(
            id: id,
            title: bookTitle,
            author: bookAuthor,
            genre: bookGenre,
            year: bookYear,
            notes: bookNotes,
            status: bookStatus,
            isbn: bookIsbn,
            pages: pages
        )

        do {
            try self.booksStorage.updateBook(updatingBook)
        } catch {
            print("Failed to update book: \(error)")
        }
    }

    func deleteBook() {
        let id = bookId ?? UUID()

        do {
            try self.booksStorage.deleteBook(id)
        } catch {
            print("Failed to delete book: \(error)")
        }
    }
}
