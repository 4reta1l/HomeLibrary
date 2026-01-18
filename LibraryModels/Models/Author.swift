//
//  Author.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 05/01/2026.
//

import Foundation

public struct Author: Identifiable, Equatable, Hashable, Codable {

    public let id: UUID
    public let displayName: String

    public init(id: UUID = UUID(), displayName: String) {
        self.id = id
        self.displayName = displayName
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id &&
        lhs.displayName == rhs.displayName
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
