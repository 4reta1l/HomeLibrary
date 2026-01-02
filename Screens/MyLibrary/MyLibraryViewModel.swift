//
//  MyLibraryViewModel.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 12/12/2025.
//

import Foundation

@Observable
final class MyLibraryViewModel {

    private let booksStorage: BooksStorage
    var books: [Book]

    var searchText: String = ""

    var filteredBooks: [Book] {
        if searchText.isEmpty {
            return books
        }

        return books.filter { book in
            book.title.localizedCaseInsensitiveContains(searchText) ||
            (book.author?.localizedCaseInsensitiveContains(searchText) ?? false)
        }
    }

    init(booksStorage: BooksStorage = CDStorage.shared) {
        self.booksStorage = booksStorage
        self.books = booksStorage.getBooks().reversed()
    }

    func reloadData() {
        self.books = booksStorage.getBooks().reversed()
    }
}
