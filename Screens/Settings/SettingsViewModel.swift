//
//  SettingsViewModel.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 17/01/2026.
//

import Foundation

final class SettingsViewModel {

    private var booksStorage: BooksStorage

    var books: [Book]

    init(booksStorage: BooksStorage = CDStorage.shared) {
        self.booksStorage = booksStorage
        self.books = booksStorage.getBooks()
    }
}
