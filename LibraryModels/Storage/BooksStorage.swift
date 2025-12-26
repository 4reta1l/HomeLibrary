//
//  BooksStorage.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 22/12/2025.
//

import Foundation

public protocol BooksStorage {
    func getBooks() -> [Book]

    func addBook(_ book: Book)

    func updateBook(_ book: Book)

    func deleteBook(_ book: Book)
}
