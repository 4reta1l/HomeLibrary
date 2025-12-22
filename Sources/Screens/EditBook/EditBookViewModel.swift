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
    var bookTitle: String
    var bookAuthor: String
    var bookGenre: Genre
    var bookYear: Int
    var bookPages: String
    var bookStatus: Status
    var bookNotes: String
    var bookIsbn: String

    init(
        booksStorage: BooksStorage = Storage.shared,
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
}
