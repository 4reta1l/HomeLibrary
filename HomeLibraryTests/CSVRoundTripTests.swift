//
//  CSVRoundTripTests.swift
//  HomeLibraryTests
//
//  Created by Maksym Pyvovarov on 01/09/2026.
//

import Testing
import Foundation
@testable import HomeLibrary

struct CSVRoundTripTests {

    @Test("Awkward values survive an export and re-parse")
    func roundTripPreservesAwkwardValues() throws {
        let book = Book(
            id: UUID(),
            title: "He said \"hi\", loudly",
            authors: [],
            genres: [],
            notes: "line one\nline two",
            status: .reading,
            series: nil,
            category: .default
        )

        let csv = CSVExporter().export([book])
        let rows = try CSVParser().parse(csv)

        #expect(rows.count == 2)          // header + one book

        let row = CSVRow(headers: rows[0], fields: rows[1])
        #expect(row["id"] == book.id.uuidString)
        #expect(row["title"] == "He said \"hi\", loudly")
        #expect(row["notes"] == "line one\nline two")
        #expect(row["status"] == "reading")
    }
}
