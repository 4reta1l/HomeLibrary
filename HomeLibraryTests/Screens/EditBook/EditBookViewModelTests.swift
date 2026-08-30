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

    private func makeAddBookViewModel() -> EditBookViewModel {
        let category = Category(name: "Owned")
        return EditBookViewModel(
            state: .addBook(category: category),
            categoriesStorage: FakeCategoriesStorage(categories: [category])
        )
    }
}
