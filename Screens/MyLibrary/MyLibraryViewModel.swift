//
//  MyLibraryViewModel.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 12/12/2025.
//

import Foundation

@Observable
final class BookFilters {
    var selectedGenres: Set<Genre> = []
    var selectedAuthors: Set<Author> = []
    var selectedYear: String = "—"
}

@Observable
final class MyLibraryViewModel {

    private let storage: CDStorage
    var books: [Book]
    var authors: [Author]
    var genres: [Genre]

    var searchText: String = ""
    var filters = BookFilters()

    var filteredBooks: [Book] {
        books
            .filter(matchesSearch)
            .filter(matchesGenre)
            .filter(matchesAuthor)
            .filter(matchesYear)
    }

    init(storage: CDStorage = CDStorage.shared) {
        self.storage = storage
        self.books = storage.getBooks().reversed()
        self.authors = storage.getAuthors()
        self.genres = storage.getGenres()
    }

    private func matchesSearch(_ book: Book) -> Bool {
        guard !searchText.isEmpty else { return true }

        return book.title.localizedCaseInsensitiveContains(searchText) ||
        book.authors
            .map(\.displayName)
            .joined(separator: ", ")
            .localizedCaseInsensitiveContains(searchText)
    }

    private func matchesGenre(_ book: Book) -> Bool {
        guard !filters.selectedGenres.isEmpty else { return true }

        return !Set(book.genres).isDisjoint(with: filters.selectedGenres)
    }


    private func matchesAuthor(_ book: Book) -> Bool {
        guard !filters.selectedAuthors.isEmpty else { return true }

        return !Set(book.authors).isDisjoint(with: filters.selectedAuthors)
    }


    private func matchesYear(_ book: Book) -> Bool {
        guard let year = Int(filters.selectedYear ?? "") else { return true }
        return book.year == year
    }

    func filteredAuthorsString(_ authors: [Author]) -> String {
        authors
        .sorted { $0.displayName.localizedCaseInsensitiveCompare($1.displayName) == .orderedAscending }
        .map(\.displayName)
        .joined(separator: ", ")
    }

    func reloadData() {
        self.books = storage.getBooks().reversed()
        self.authors = storage.getAuthors()
        self.genres = storage.getGenres()
    }
}
