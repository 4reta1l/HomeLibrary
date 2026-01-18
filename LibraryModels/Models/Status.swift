//
//  Status.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 12/12/2025.
//

public enum Status: String, CaseIterable, Codable {
    case unread
    case reading
    case completed
}

public extension Status {
    var displayString: String {
        switch self {
        case .unread: "unread"
        case .reading: "reading"
        case .completed: "completed"
        }
    }

    var displaySign: String {
        switch self {
        case .unread: "xmark"
        case .reading: "book.fill"
        case .completed: "checkmark.seal"
        }
    }
}
