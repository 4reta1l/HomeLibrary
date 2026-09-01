//
//  CSVParser.swift
//  HomeLibraryTests
//
//  Created by Maksym Pyvovarov on 01/09/2026.
//

import Foundation

/// CSV parsing extracted from CDStorage+Import.
/// Behaviour is intentionally unchanged from the original implementation.
public struct CSVParser {

    public enum ParseError: Error, Equatable {
        case unterminatedQuote
    }

    public init() {}

    public func parse(_ text: String) throws -> [[String]] {
        text
            .components(separatedBy: .newlines)
            .map(parseRow)
            .filter { !$0.allSatisfy(\.isEmpty) }
    }

    private func parseRow(_ row: String) -> [String] {
        var result: [String] = []
        var current = ""
        var insideQuotes = false

        for character in row {
            if character == "\"" {
                insideQuotes.toggle()
            } else if character == "," && !insideQuotes {
                result.append(current)
                current = ""
            } else {
                current.append(character)
            }
        }

        result.append(current)
        return result.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
    }
}
