//
//  SettingsView.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 17/01/2026.
//

import SwiftUI
internal import UniformTypeIdentifiers

struct SettingsView: View {

    @Environment(LibraryStore.self) private var store
    @State private var exportURL: URL?
    @State private var exportType: ExportType?
    @State private var showImportCSV: Bool = false

    enum ExportType {
        case json
        case csv
    }

    var body: some View {
        NavigationStack {
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

                Section("Import") {
                    Button {
                        showImportCSV.toggle()
                    } label: {
                        Label("Import as CSV", systemImage: "square.and.arrow.down")
                    }
                }
            }
            .fileImporter(
                isPresented: $showImportCSV,
                allowedContentTypes: [.commaSeparatedText]
            ) { result in
                do {
                    let url = try result.get()

                    guard url.startAccessingSecurityScopedResource() else {
                        print("Could not access file")
                        return
                    }
                    defer { url.stopAccessingSecurityScopedResource() }

                    try CDStorage.shared.importBooks(from: url)
                } catch {
                    print("CSV import failed:", error)
                }
            }

            .navigationTitle("Settings")
        }
    }

    func exportLibraryJSON() {
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("library.json")

        do {
            let data = try JSONEncoder().encode(store.books)
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

        do {
            let csv = CSVExporter().export(store.books)
            try csv.write(to: url, atomically: true, encoding: .utf8)

            exportURL = url
            exportType = .csv
        } catch {
            print("CSV export failed: \(error)")
        }
    }
}
