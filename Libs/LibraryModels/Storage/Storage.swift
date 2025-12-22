//
//  Storage.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 22/12/2025.
//

import Foundation

final class Storage: BooksStorage {

    public static let shared = Storage()

    var books: [Book]

    init() {
        let firstBook = Book(
            title: "Harry Potter 1",
            author: "Who knows",
            genre: .adventure,
            year: 2012,
            notes: "Amazing Book",
            status: .completed,
            isbn: "",
            pages: 456
        )

        let secondBook = Book(
            title: "Harry Potter 2",
            author: "Rouling",
            genre: .horror,
            year: 2014,
            notes: "",
            status: .reading,
            isbn: "",
            pages: 322
        )

        self.books = [firstBook, secondBook]
    }

    func getBooks() -> [Book] {
        return books
    }

    func addBook(_ book: Book) {
        self.books.append(book)

    }

    func updateBook(_ book: Book) {
        //TODO: search for a book by id to modify it
    }

    func deleteBook(_ book: Book) {
        //TODO: search for a book id to delete
    }
}
