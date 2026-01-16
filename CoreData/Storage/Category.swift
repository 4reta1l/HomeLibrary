//
//  Category.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 16/01/2026.
//

import Foundation

public struct Category: Identifiable, Hashable, Equatable {

    public let id: UUID
    public let name: String

    public static let `default` = Category(name: DefaultCategories.owned.name)
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

public enum DefaultCategories: CaseIterable {
    case owned
    case wishlist
    case currentlyReading
    case borrowed
    case favorites
    case forStudy
    case forFun

    var name: String {
        switch self {
        case .owned: "Owned"
        case .wishlist: "Wishlist"
        case .currentlyReading: "Currently Reading"
        case .borrowed: "Borrowed"
        case .favorites: "Favorites"
        case .forStudy: "For Study"
        case .forFun: "For Fun"
        }
    }
}
