//
//  Series.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 14/01/2026.
//

import Foundation

public struct Series: Identifiable, Hashable, Equatable {

    public let id: UUID
    public let name: String

    public init(id: UUID = UUID(), name: String) {
        self.id = id
        self.name = name
    }


    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id &&
        lhs.name == rhs.name
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
