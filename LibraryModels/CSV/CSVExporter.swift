//
//  CSVExporter.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 01/09/2026.
//

import Foundation

public struct CSVExporter {

    public static let headers = [
        "id", "title", "status", "authors", "genres", "year",
        "pages", "isbn", "category", "publisher", "series", "notes"
    ]

    public init() {}

    public func export(_ books: [Book]) -> String {
        var lines = [Self.headers.joined(separator: ",")]

        for book in books {
            let fields = [
                book.id.uuidString,
                book.title,
                book.status.rawValue,
                book.authors.map(\.displayName).joined(separator: "; "),
                book.genres.map(\.name).joined(separator: "; "),
                book.year.map(String.init) ?? "",
                book.pages.map(String.init) ?? "",
                book.isbn ?? "",
                book.category.name,
                book.publisher?.name ?? "",
                book.series?.name ?? "",
                book.notes ?? ""
            ]
            lines.append(fields.map(escape).joined(separator: ","))
        }

        return lines.joined(separator: "\n") + "\n"
    }

    private func escape(_ value: String) -> String {
        guard value.contains(where: { $0 == "," || $0 == "\"" || $0 == "\n" || $0 == "\r" })
        else { return value }
        return "\"" + value.replacingOccurrences(of: "\"", with: "\"\"") + "\""
    }
}
