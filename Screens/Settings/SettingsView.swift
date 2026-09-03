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
    @State private var showImportCSV = false
    @State private var errorMessage: String?
    @State private var isShowingError = false

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
            .navigationTitle("Settings")
            .fileImporter(
                isPresented: $showImportCSV,
                allowedContentTypes: [.commaSeparatedText]
            ) { result in
                importLibraryCSV(from: result)
            }
            .alert("Something went wrong", isPresented: $isShowingError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage ?? "Unknown error")
            }
        }
    }

    // MARK: - Export

    private func exportLibraryJSON() {
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("library.json")

        do {
            let data = try JSONEncoder().encode(store.books)
            try data.write(to: url)

            exportURL = url
            exportType = .json
        } catch {
            show(error)
        }
    }

    private func exportLibraryCSV() {
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("library.csv")

        do {
            let csv = CSVExporter().export(store.books)
            try csv.write(to: url, atomically: true, encoding: .utf8)

            exportURL = url
            exportType = .csv
        } catch {
            show(error)
        }
    }

    // MARK: - Import

    private func importLibraryCSV(from result: Result<URL, any Error>) {
        do {
            let url = try result.get()

            guard url.startAccessingSecurityScopedResource() else {
                show(message: "Could not open the selected file.")
                return
            }
            defer { url.stopAccessingSecurityScopedResource() }

            try store.importBooks(from: url)
        } catch {
            show(error)
        }
    }

    // MARK: - Errors

    private func show(_ error: any Error) {
        show(message: error.localizedDescription)
    }

    private func show(message: String) {
        errorMessage = message
        isShowingError = true
    }
}
