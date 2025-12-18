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

    var bookTitle: String
    var bookAuthor: String
    var bookGenre: Genre
    var bookYear: Int
    var bookPages: Int
    var bookStatus: Status
    var bookIsbn: String

    init(state: EditBookView.ViewState) {
        switch state {
        case .addBook:
            bookTitle = ""
            bookAuthor = ""
            bookGenre = .general
            bookYear = Date().year
            bookPages = 0
            bookStatus = .unread
            bookIsbn = ""

        case .editBook(let book):
            bookTitle = book.title
            bookAuthor = book.author
            bookGenre = book.genre
            bookYear = book.year
            bookPages = book.pages
            bookStatus = book.status
            bookIsbn = book.isbn
        }
    }
}
