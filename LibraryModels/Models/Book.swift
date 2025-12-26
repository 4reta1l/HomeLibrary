//
//  Book.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 12/12/2025.
//

import Foundation

public struct Book: Identifiable, Equatable, Hashable {

    public let id: UUID
    public let title: String
    public let author: String
    public let genre: Genre
    public let year: Int
    public let notes: String
    public let status: Status
    public let isbn: String
    public let pages: Int

    public init(id: UUID = UUID(), title: String, author: String, genre: Genre, year: Int, notes: String, status: Status, isbn: String, pages: Int) {
        self.id = id
        self.title = title
        self.author = author
        self.genre = genre
        self.year = year
        self.notes = notes
        self.status = status
        self.isbn = isbn
        self.pages = pages
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id &&
        lhs.title == rhs.title &&
        lhs.author == rhs.author &&
        lhs.genre == rhs.genre &&
        lhs.year == rhs.year &&
        lhs.notes == rhs.notes &&
        lhs.status == rhs.status &&
        lhs.isbn == rhs.isbn &&
        lhs.pages == rhs.pages
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
