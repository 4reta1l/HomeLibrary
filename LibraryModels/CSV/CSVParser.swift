//
//  CSVParser.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 01/09/2026.
//

import Foundation

/// Parses CSV text according to RFC 4180.
///
/// A field wrapped in double quotes may contain commas, line breaks and
/// escaped quotes (a literal `"` is written as `""`).
public struct CSVParser {

    public enum ParseError: Error, Equatable, LocalizedError {
        case unterminatedQuote

        public var errorDescription: String? {
            switch self {
            case .unterminatedQuote:
                "The file contains a quotation mark that is never closed."
            }
        }
    }

    public init() {}

    /// Splits a CSV document into rows of fields. Rows that are entirely
    /// empty are dropped, so a trailing newline does not produce a blank row.
    public func parse(_ text: String) throws -> [[String]] {
        let characters = Array(text)
        var rows: [[String]] = []
        var row: [String] = []
        var index = 0

        while index < characters.count {
            let result = try scanField(characters, from: index)
            row.append(result.field)
            index = result.next

            if result.endsRow {
                rows.append(row)
                row = []
            }
        }

        if !row.isEmpty {
            rows.append(row)
        }

        return rows.filter { !$0.allSatisfy(\.isEmpty) }
    }

    /// Reads one field starting at `start`.
    /// - Returns: the field's value, the index to continue from, and whether
    ///   this field was the last one in its row.
    private func scanField(
        _ characters: [Character],
        from start: Int
    ) throws -> (field: String, next: Int, endsRow: Bool) {

        var field = ""
        var index = start
        var insideQuotes = false

        while index < characters.count {
            let character = characters[index]

            if insideQuotes {
                if character == "\"" {
                    if index + 1 < characters.count, characters[index + 1] == "\"" {
                        field.append("\"")      // escaped quote
                        index += 2
                    } else {
                        insideQuotes = false    // closing quote
                        index += 1
                    }
                } else {
                    field.append(character)     // commas and newlines are literal here
                    index += 1
                }
                continue
            }

            switch character {
            case "\"":
                insideQuotes = true
                index += 1
            case ",":
                return (field, index + 1, false)
            case "\n":
                return (field, index + 1, true)
            case "\r":
                index += 1                      // skip the CR of a CRLF pair
            default:
                field.append(character)
                index += 1
            }
        }

        if insideQuotes {
            throw ParseError.unterminatedQuote
        }

        return (field, index, true)
    }
}
