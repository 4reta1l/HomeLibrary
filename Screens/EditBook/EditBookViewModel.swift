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
    private var bookId: UUID
    var bookTitle: String = ""
    var bookAuthors: [Author] = []
    var bookNotes: String = ""
    var bookIsbn: String = ""
    var bookPages: String = ""
    var bookYear: String = ""
    var bookStatus: Status = .unread
    var bookGenres: [Genre] = []

    var editedBook: Book?

    init(
        booksStorage: BooksStorage = CDStorage.shared,
        state: EditBookView.ViewState
    ) {
        self.booksStorage = booksStorage

        switch state {
        case .addBook:
            bookId = UUID()
            bookTitle = ""
            bookStatus = .unread
            bookYear = "—"

        case .editBook(let book):
            bookId = book.id
            bookTitle = book.title
            bookAuthors = book.authors
            bookGenres = book.genres
            bookYear = book.displayYear
            bookPages = book.displayPagesForEdit
            bookStatus = book.status
            bookNotes = book.displayNotes
            bookIsbn = book.displayISBN
            editedBook = book
        }
    }

    let yearsArray = Array(1800...Date().year)

    func filteredAuthorsString() -> String {
        bookAuthors
        .sorted { $0.displayName.localizedCaseInsensitiveCompare($1.displayName) == .orderedAscending }
        .map(\.displayName)
        .joined(separator: ", ")
    }

    func addBook() {

        let newBook = Book(
            id: bookId,
            title: bookTitle,
            authors: bookAuthors,
            genres: bookGenres,
            notes: bookNotes.isEmpty ? nil : bookNotes,
            status: bookStatus,
            isbn: bookIsbn.isEmpty ? nil : bookIsbn,
            pages: Int(bookPages),
            year: Int(bookYear)
        )

        do {
            try self.booksStorage.addBook(newBook)
        } catch {
            print("Failed to add book: \(error)")
        }
    }

    func updateBook() {

        let updatingBook = Book(
            id: bookId,
            title: bookTitle,
            authors: bookAuthors,
            genres: bookGenres,
            notes: bookNotes.isEmpty ? nil : bookNotes,
            status: bookStatus,
            isbn: bookIsbn.isEmpty ? nil : bookIsbn,
            pages: Int(bookPages),
            year: Int(bookYear)
        )

        do {
            try self.booksStorage.updateBook(updatingBook)
        } catch {
            print("Failed to update book: \(error)")
        }
    }

    func deleteBook() {
        if let book = self.editedBook {
            do {
                try self.booksStorage.deleteBook(book)
            } catch {
                print("Failed to delete book: \(error)")
            }
        }
    }
}
