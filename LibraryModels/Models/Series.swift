//
//  Series.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 14/01/2026.
//

import Foundation

public struct Series: Identifiable, Hashable, Equatable, Codable {

    public let id: UUID
    public let name: String
    public let authors: [Author]

    public init(id: UUID = UUID(), name: String, authors: [Author]) {
        self.id = id
        self.name = name
        self.authors = authors
    }


    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.authors == rhs.authors
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
