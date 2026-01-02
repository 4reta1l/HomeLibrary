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
    public let status: Status
    public let author: String?
    public let genre: Genre
    public let notes: String?
    public let isbn: String?
    public let pages: Int?
    public let year: Int?

    public init(
        id: UUID,
        title: String,
        author: String? = nil,
        genre: Genre,
        notes: String? = nil,
        status: Status,
        isbn: String? = nil,
        pages: Int? = nil,
        year: Int? = nil
    ) {
        self.id = id
        self.title = title
        self.author = author
        self.genre = genre
        self.notes = notes
        self.status = status
        self.isbn = isbn
        self.pages = pages
        self.year = year
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
