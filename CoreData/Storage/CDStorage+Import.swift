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

    /// Import books from CSV file URL
    func importBooks(from url: URL) throws {
        let context = container.newBackgroundContext()

        context.performAndWait {
            do {
                let csv = try String(contentsOf: url, encoding: .utf8)
                let rows = csv.components(separatedBy: .newlines)

                guard rows.count > 1 else { return }

                // Skip header
                for row in rows.dropFirst() {
                    let columns = self.parseCSVRow(row)
                    guard !columns.isEmpty else { continue }

                    self.createCDBook(from: columns, context: context)
                }

                if context.hasChanges {
                    try context.save()
                }
            } catch {
                context.rollback()
                print("CSV import failed:", error)
            }
        }
    }

    // MARK: - CSV Parsing

    private func parseCSVRow(_ row: String) -> [String] {
        var result: [String] = []
        var current = ""
        var insideQuotes = false

        for char in row {
            if char == "\"" {
                insideQuotes.toggle()
            } else if char == "," && !insideQuotes {
                result.append(current)
                current = ""
            } else {
                current.append(char)
            }
        }

        result.append(current)
        return result.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
    }

    private func createCDBook(from columns: [String], context: NSManagedObjectContext) {

        guard columns.count >= 12 else { return }

        let book = CDBook(context: context)
        book.id = UUID()
        book.title = columns[1]
        book.rawStatus = columns[2]

        book.year = Int(columns[5]).map { NSNumber(value: $0) }
        book.pages = Int(columns[6]).map { NSNumber(value: $0) }
        book.isbn = columns[7].isEmpty ? nil : columns[7]
        book.notes = columns[11].isEmpty ? nil : columns[11]

        book.category = fetchOrCreateCategory(
            name: columns[8],
            context: context
        )

        book.publisher = fetchOrCreatePublisher(
            name: columns[9],
            context: context
        )

        if !columns[10].isEmpty {
            book.series = fetchOrCreateSeries(
                name: columns[10],
                context: context
            )
        }

        book.authors = Set(
            columns[3]
                .split(separator: ";")
                .map {
                    fetchOrCreateAuthor(
                        name: $0.trimmingCharacters(in: .whitespaces),
                        context: context
                    )
                }
        )

        book.genres = Set(
            columns[4]
                .split(separator: ";")
                .map {
                    fetchOrCreateGenre(
                        name: $0.trimmingCharacters(in: .whitespaces),
                        context: context
                    )
                }
        )
    }

}
