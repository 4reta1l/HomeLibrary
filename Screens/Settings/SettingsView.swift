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

    var body: some View {
        Form {
            Section("Export") {
                Button {
                    exportLibrary()
                } label: {
                    Label("Try to export library", systemImage: "tray.and.arrow.down")
                }

                if let exportURL {
                    ShareLink(
                        item: exportURL,
                        preview: SharePreview("Share Export")
                    ) {
                        Label("Export Library", systemImage: "square.and.arrow.up")
                    }
                }
            }
        }
        .navigationTitle("Settings")
    }

    func exportLibrary() {
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("library.json")

        do {
            let data = try JSONEncoder().encode(viewModel.books)
            try data.write(to: url)
            exportURL = url
        } catch {
            print("Export failed: \(error)")
        }
        print("Books count: \(viewModel.books.count)")
    }
}
