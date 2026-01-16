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

    private var bookId: UUID

    var bookTitle: String = ""
    var bookAuthors: [Author] = []
    var bookNotes: String = ""
    var bookIsbn: String = ""
    var bookPages: String = ""
    var bookYear: String = ""
    var bookStatus: Status = .unread
    var bookGenres: [Genre] = []
    var bookPublisher: Publisher?
    var bookSeries: Series?
    var bookCategory: Category

    var editedBook: Book?

    init(
        state: EditBookView.ViewState
    ) {

        switch state {
        case .addBook(let category):
            bookId = UUID()
            bookStatus = .unread
            bookYear = "—"

            do {
                let realCategory = try CDStorage.shared.getCategoryByName(category.name)
                bookCategory = realCategory
            } catch {
                bookCategory = Category.default
            }

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
            bookPublisher = book.publisher
            bookSeries = book.series
            bookCategory = book.category
        }
    }

    let yearsArray = Array(1800...Date().year)

    func filteredAuthorsString() -> String {
        bookAuthors
        .sorted { $0.displayName.localizedCaseInsensitiveCompare($1.displayName) == .orderedAscending }
        .map(\.displayName)
        .joined(separator: ", ")
    }

    func makeBook() -> Book {
        Book(
            id: bookId,
            title: bookTitle,
            authors: bookAuthors,
            genres: bookGenres,
            notes: bookNotes.isEmpty ? nil : bookNotes,
            status: bookStatus,
            isbn: bookIsbn.isEmpty ? nil : bookIsbn,
            pages: Int(bookPages),
            year: Int(bookYear),
            publisher: bookPublisher,
            series: bookSeries,
            category: bookCategory
        )
    }
}
