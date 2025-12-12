//
//  MyLibraryViewModel.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 12/12/2025.
//

import Foundation

@Observable
final class MyLibraryViewModel {
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
}
