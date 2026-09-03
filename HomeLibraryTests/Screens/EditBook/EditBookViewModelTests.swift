//
//  EditBookViewModelTests.swift
//  HomeLibraryTests
//

import Testing
import Foundation
@testable import HomeLibrary

struct EditBookViewModelTests {

    @Test func addBookState_resolvesRealCategoryFromStorage() {
        let category = Category(name: "Wishlist")
        let categoriesStorage = FakeCategoriesStorage(categories: [category])

        let viewModel = EditBookViewModel(
            state: .addBook(category: category),
            categoriesStorage: categoriesStorage
        )

        #expect(viewModel.bookCategory == category)
        #expect(viewModel.bookStatus == .unread)
        #expect(viewModel.bookYear == "—")
        #expect(viewModel.bookTitle.isEmpty)
    }

    @Test func addBookState_fallsBackToDefaultCategoryWhenNotFound() {
        let unknownCategory = Category(name: "Ghost")

        let viewModel = EditBookViewModel(
            state: .addBook(category: unknownCategory),
            categoriesStorage: FakeCategoriesStorage(categories: [])
        )

        #expect(viewModel.bookCategory == Category.default)
    }

    @Test func editBookState_prefillsFieldsFromBook() {
        let author = Author(displayName: "Frank Herbert")
        let genre = Genre(name: "Science Fiction")
        let category = Category(name: "Owned")
        let book = Book(
            id: UUID(),
            title: "Dune",
            authors: [author],
            genres: [genre],
            notes: "Great book",
            status: .reading,
            isbn: "9780441013593",
            pages: 412,
            year: 1965,
            publisher: nil,
            series: nil,
            category: category
        )

        let viewModel = EditBookViewModel(state: .editBook(book: book))

        #expect(viewModel.bookTitle == "Dune")
        #expect(viewModel.bookAuthors == [author])
        #expect(viewModel.bookGenres == [genre])
        #expect(viewModel.bookYear == "1965")
        #expect(viewModel.bookPages == "412")
        #expect(viewModel.bookStatus == .reading)
        #expect(viewModel.bookNotes == "Great book")
        #expect(viewModel.bookIsbn == "9780441013593")
        #expect(viewModel.editedBook == book)
    }

    @Test func makeBook_mapsBlankFieldsToNil() {
        let viewModel = makeAddBookViewModel()
        viewModel.bookTitle = "Some Title"

        let book = viewModel.makeBook()

        #expect(book.title == "Some Title")
        #expect(book.notes == nil)
        #expect(book.isbn == nil)
        #expect(book.pages == nil)
        #expect(book.year == nil)
    }

    @Test func makeBook_parsesNumericAndTextFields() {
        let viewModel = makeAddBookViewModel()
        viewModel.bookTitle = "Some Title"
        viewModel.bookPages = "250"
        viewModel.bookYear = "2020"
        viewModel.bookNotes = "note"
        viewModel.bookIsbn = "123"

        let book = viewModel.makeBook()

        #expect(book.pages == 250)
        #expect(book.year == 2020)
        #expect(book.notes == "note")
        #expect(book.isbn == "123")
    }

    @Test func filteredAuthorsString_sortsAuthorsAlphabetically() {
        let viewModel = makeAddBookViewModel()
        viewModel.bookAuthors = [
            Author(displayName: "Ursula K. Le Guin"),
            Author(displayName: "Isaac Asimov"),
            Author(displayName: "Frank Herbert")
        ]

        #expect(viewModel.filteredAuthorsString() == "Frank Herbert, Isaac Asimov, Ursula K. Le Guin")
    }

    @Test func applyScannedISBN_setsBookIsbnImmediately() {
        let viewModel = makeAddBookViewModel()

        viewModel.applyScannedISBN("9780441013593")

        #expect(viewModel.bookIsbn == "9780441013593")
    }

    @Test func applyLookupResult_fillsEmptyFieldsOnly() {
        let viewModel = makeAddBookViewModel()
        viewModel.bookTitle = "Existing Title"

        viewModel.applyLookupResult(
            BookLookupResult(
                title: "Scanned Title",
                authors: ["Frank Herbert"],
                publisher: "Ace Books",
                year: 1990,
                pages: 412,
                genres: ["Science Fiction"]
            )
        )

        #expect(viewModel.bookTitle == "Existing Title")
        #expect(viewModel.bookAuthors.map(\.displayName) == ["Frank Herbert"])
        #expect(viewModel.bookGenres.map(\.name) == ["Science Fiction"])
        #expect(viewModel.bookPublisher?.name == "Ace Books")
        #expect(viewModel.bookPages == "412")
        #expect(viewModel.bookYear == "1990")
    }

    @Test func applyLookupResult_reusesExistingAuthorGenrePublisherByName() {
        let existingAuthor = Author(displayName: "Frank Herbert")
        let existingGenre = Genre(name: "Science Fiction")
        let existingPublisher = Publisher(name: "Ace Books")

        let viewModel = makeAddBookViewModel(
            authorsStorage: FakeAuthorsStorage(authors: [existingAuthor]),
            publishersStorage: FakePublishersStorage(publishers: [existingPublisher]),
            genresStorage: FakeGenresStorage(genres: [existingGenre])
        )

        viewModel.applyLookupResult(
            BookLookupResult(
                title: nil,
                authors: ["frank herbert"],
                publisher: "ACE BOOKS",
                year: nil,
                pages: nil,
                genres: ["science fiction"]
            )
        )

        #expect(viewModel.bookAuthors == [existingAuthor])
        #expect(viewModel.bookGenres == [existingGenre])
        #expect(viewModel.bookPublisher == existingPublisher)
    }

    @Test func applyLookupResult_leavesAlreadyFilledFieldsUntouched() {
        let viewModel = makeAddBookViewModel()
        let existingAuthor = Author(displayName: "Already Set")
        viewModel.bookAuthors = [existingAuthor]
        viewModel.bookPages = "100"
        viewModel.bookYear = "1999"
        viewModel.bookPublisher = Publisher(name: "Existing Publisher")

        viewModel.applyLookupResult(
            BookLookupResult(
                title: nil,
                authors: ["Someone Else"],
                publisher: "Other Publisher",
                year: 2020,
                pages: 999,
                genres: []
            )
        )

        #expect(viewModel.bookAuthors == [existingAuthor])
        #expect(viewModel.bookPages == "100")
        #expect(viewModel.bookYear == "1999")
        #expect(viewModel.bookPublisher?.name == "Existing Publisher")
    }

    private func makeAddBookViewModel(
        authorsStorage: AuthorsStorage = FakeAuthorsStorage(),
        publishersStorage: PublishersStorage = FakePublishersStorage(),
        genresStorage: GenresStorage = FakeGenresStorage(),
        bookLookupService: BookLookupService = FakeBookLookupService()
    ) -> EditBookViewModel {
        let category = Category(name: "Owned")
        return EditBookViewModel(
            state: .addBook(category: category),
            categoriesStorage: FakeCategoriesStorage(categories: [category]),
            bookLookupService: bookLookupService,
            authorsStorage: authorsStorage,
            publishersStorage: publishersStorage,
            genresStorage: genresStorage
        )
    }
}
