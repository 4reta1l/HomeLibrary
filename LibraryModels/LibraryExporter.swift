//
//  LibraryExporter.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 17/01/2026.
//

import Foundation

final class LibraryExporter {

    static func exportJSON(books: [Book]) throws -> URL {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]

        let data = try encoder.encode(books)

        let url = FileManager.default
            .temporaryDirectory
            .appendingPathComponent("Library.json")

        try data.write(to: url)
        return url
    }
}
