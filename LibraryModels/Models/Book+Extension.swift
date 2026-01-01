//
//  Book+Extension.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 30/12/2025.
//

import Foundation

extension Book {
    var displayAuthor: String {
        author?.isEmpty == false ? author! : ""
    }

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
