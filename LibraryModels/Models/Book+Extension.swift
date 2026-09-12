//
//  Book+Extension.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 30/12/2025.
//

import Foundation

extension Book {
    var displayNotes: String {
        notes?.isEmpty == false ? notes! : ""
    }

    var displayISBN: String {
        isbn?.isEmpty == false ? isbn! : ""
    }

    var displayPages: String {
        pages.map { "\($0)" } ?? "—"
    }

    var displayPagesForEdit: String {
        pages.map { "\($0)" } ?? ""
    }

    var displayYear: String {
        year.map { "\($0)" } ?? "—"
    }
}

extension Array where Element == Book {
    func displayCount(for category: Category) -> String {
        let count = filter { $0.category == category }.count
        return count == 1 ? "1 book" : "\(count) books"
    }
}
