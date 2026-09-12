//
//  Genre+Extension.swift
//  HomeLibrary
//

import Foundation

extension Array where Element == Genre {
    var displayJoinedNames: String {
        sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
            .map(\.name)
            .joined(separator: ", ")
    }
}
