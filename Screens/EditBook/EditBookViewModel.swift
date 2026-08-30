//
//  EditBookViewModel.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 17/12/2025.
//

import Foundation

// TODO: Protocol
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

    var isScannerPresented = false
    var isLookingUpBook = false
    var lookupErrorMessage: String?

    private let bookLookupService: BookLookupService
    private let authorsStorage: AuthorsStorage
    private let publishersStorage: PublishersStorage
    private let genresStorage: GenresStorage

    init(
        state: EditBookView.ViewState,
        categoriesStorage: CategoriesStorage = CDStorage.shared,
        bookLookupService: BookLookupService = OpenLibraryBookLookupService(),
        authorsStorage: AuthorsStorage = CDStorage.shared,
        publishersStorage: PublishersStorage = CDStorage.shared,
        genresStorage: GenresStorage = CDStorage.shared
    ) {
        self.bookLookupService = bookLookupService
        self.authorsStorage = authorsStorage
        self.publishersStorage = publishersStorage
        self.genresStorage = genresStorage

        switch state {
        case .addBook(let category):
            bookId = UUID()
            bookStatus = .unread
            bookYear = "—"

            do {
                let realCategory = try categoriesStorage.getCategoryByName(category.name)
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

    // MARK: - Barcode Scan

    func applyScannedISBN(_ isbn: String) {
        bookIsbn = isbn
        lookupErrorMessage = nil

        Task {
            await lookUpBook(isbn: isbn)
        }
    }

    @MainActor
    private func lookUpBook(isbn: String) async {
        isLookingUpBook = true
        defer { isLookingUpBook = false }

        do {
            let result = try await bookLookupService.lookup(isbn: isbn)
            applyLookupResult(result)
        } catch BookLookupError.notFound {
            lookupErrorMessage = "No book found for this ISBN."
        } catch {
            lookupErrorMessage = "Couldn't fetch book details. Please fill them in manually."
        }
    }

    func applyLookupResult(_ result: BookLookupResult) {
        if bookTitle.isEmpty, let title = result.title {
            bookTitle = title
        }

        if bookAuthors.isEmpty, !result.authors.isEmpty {
            let existingAuthors = authorsStorage.getAuthors()
            bookAuthors = result.authors.map { name in
                existingAuthors.first {
                    $0.displayName.localizedCaseInsensitiveCompare(name) == .orderedSame
                } ?? Author(displayName: name)
            }
        }

        if bookGenres.isEmpty, !result.genres.isEmpty {
            let existingGenres = genresStorage.getGenres()
            bookGenres = result.genres.map { name in
                existingGenres.first {
                    $0.name.localizedCaseInsensitiveCompare(name) == .orderedSame
                } ?? Genre(name: name)
            }
        }

        if bookPublisher == nil, let publisherName = result.publisher {
            let existingPublisher = publishersStorage.getPublishers().first {
                $0.name.localizedCaseInsensitiveCompare(publisherName) == .orderedSame
            }
            bookPublisher = existingPublisher ?? Publisher(name: publisherName)
        }

        if bookPages.isEmpty, let pages = result.pages {
            bookPages = String(pages)
        }

        if bookYear.isEmpty || bookYear == "—", let year = result.year {
            bookYear = String(year)
        }
    }
}
