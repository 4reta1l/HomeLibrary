//
//  SettingsView.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 17/01/2026.
//

import SwiftUI

struct SettingsView: View {

    @State private var viewModel = SettingsViewModel()
    @State private var exportURL: URL?
    @State private var exportType: ExportType?

    enum ExportType {
        case json
        case csv
    }

    var body: some View {
        NavigationView {
            Form {
                Section("Export") {

                    Button {
                        exportLibraryJSON()
                    } label: {
                        Label("Export as JSON", systemImage: "curlybraces")
                    }

                    Button {
                        exportLibraryCSV()
                    } label: {
                        Label("Export as CSV", systemImage: "tablecells")
                    }

                    if let exportURL, let exportType {
                        ShareLink(item: exportURL) {
                            Label(
                                "Share \(exportType == .json ? "JSON" : "CSV")",
                                systemImage: "square.and.arrow.up"
                            )
                        }
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }

    func exportLibraryJSON() {
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("library.json")

        do {
            let data = try JSONEncoder().encode(viewModel.books)
            try data.write(to: url)

            exportURL = url
            exportType = .json
        } catch {
            print("Export failed: \(error)")
        }
    }

    func exportLibraryCSV() {
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("library.csv")

        var csv = ""

        csv += "id,title,status,authors,genres,year,pages,isbn,category,publisher,series,notes\n"

        for book in viewModel.books {
            let row = [
                book.id.uuidString,
                escape(book.title),
                book.status.rawValue,
                escape(book.authors.map(\.displayName).joined(separator: "; ")),
                escape(book.genres.map(\.name).joined(separator: "; ")),
                book.year.map(String.init) ?? "",
                book.pages.map(String.init) ?? "",
                book.isbn ?? "",
                escape(book.category.name),
                book.publisher?.name ?? "",
                book.series?.name ?? "",
                escape(book.notes ?? "")
            ]

            csv += row.joined(separator: ",") + "\n"
        }

        do {
            try csv.write(to: url, atomically: true, encoding: .utf8)
            exportURL = url
            exportType = .csv
        } catch {
            print("CSV export failed:", error)
        }
    }

    private func escape(_ value: String) -> String {
        if value.contains(",") || value.contains("\"") || value.contains("\n") {
            return "\"\(value.replacingOccurrences(of: "\"", with: "\"\""))\""
        }
        return value
    }

}
