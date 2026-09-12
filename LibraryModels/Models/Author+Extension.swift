//
//  Author+Extension.swift
//  HomeLibrary
//

import Foundation

extension Array where Element == Author {
    var displayJoinedNames: String {
        sorted { $0.displayName.localizedCaseInsensitiveCompare($1.displayName) == .orderedAscending }
            .map(\.displayName)
            .joined(separator: ", ")
    }
}
