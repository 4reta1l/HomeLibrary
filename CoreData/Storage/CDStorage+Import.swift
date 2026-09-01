//
//  CDStorage+Import.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 18/01/2026.
//

import Foundation
import CoreData

extension CDStorage {

    // MARK: - Public API

    /// Import books from a CSV file URL. Rows are matched to existing books by id.
    func importBooks(from url: URL) throws {
        let text = try String(contentsOf: url, encoding: .utf8)
        let rows = try CSVParser().parse(text)

        guard let header = rows.first else { return }
        let headers = header.map { $0.trimmingCharacters(in: .whitespaces) }

        let context = container.newBackgroundContext()
        var thrownError: Error?

        context.performAndWait {
            do {
                for fields in rows.dropFirst() {
                    let row = CSVRow(headers: headers, fields: fields)
                    try self.upsertBook(from: row, context: context)
                }
                if context.hasChanges { try context.save() }
            } catch {
                context.rollback()
                thrownError = error
            }
        }

        if let thrownError { throw thrownError }
    }

    // MARK: - Row mapping

    private func upsertBook(from row: CSVRow, context: NSManagedObjectContext) throws {
        guard let title = row["title"] else { return }

        let id = row["id"].flatMap { UUID(uuidString: $0) } ?? UUID()

        let request = CDBook.fetchRequest().filteredById(id)
        let book = try context.fetch(request).first ?? CDBook(context: context)

        book.id = id
        book.title = title
        book.rawStatus = row["status"] ?? Status.unread.rawValue
        book.year = row["year"].flatMap { Int($0) }.map { NSNumber(value: $0) }
        book.pages = row["pages"].flatMap { Int($0) }.map { NSNumber(value: $0) }
        book.isbn = row["isbn"]
        book.notes = row["notes"]

        book.category = fetchOrCreateCategory(
            name: row["category"] ?? Category.default.name,
            context: context
        )

        book.publisher = row["publisher"].map {
            fetchOrCreatePublisher(name: $0, context: context)
        }

        book.series = row["series"].map {
            fetchOrCreateSeries(name: $0, context: context)
        }

        book.authors = Set(
            splitList(row["authors"]).map {
                fetchOrCreateAuthor(name: $0, context: context)
            }
        )

        book.genres = Set(
            splitList(row["genres"]).map {
                fetchOrCreateGenre(name: $0, context: context)
            }
        )
    }

    /// Splits a semicolon-separated cell ("Tolkien; Lewis") into trimmed values.
    private func splitList(_ value: String?) -> [String] {
        guard let value else { return [] }
        return value
            .split(separator: ";")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
    }
}
