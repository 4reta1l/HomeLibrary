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
    public let authors: [Author]
    public let genres: [Genre]
    public let notes: String?
    public let isbn: String?
    public let pages: Int?
    public let year: Int?
    public let publisher: Publisher?

    public init(
        id: UUID,
        title: String,
        authors: [Author],
        genres: [Genre],
        notes: String? = nil,
        status: Status,
        isbn: String? = nil,
        pages: Int? = nil,
        year: Int? = nil,
        publisher: Publisher? = nil
    ) {
        self.id = id
        self.title = title
        self.authors = authors
        self.genres = genres
        self.notes = notes
        self.status = status
        self.isbn = isbn
        self.pages = pages
        self.year = year
        self.publisher = publisher
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id &&
        lhs.title == rhs.title &&
        lhs.authors == rhs.authors &&
        lhs.genres == rhs.genres &&
        lhs.year == rhs.year &&
        lhs.notes == rhs.notes &&
        lhs.status == rhs.status &&
        lhs.isbn == rhs.isbn &&
        lhs.pages == rhs.pages &&
        lhs.publisher == rhs.publisher
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
