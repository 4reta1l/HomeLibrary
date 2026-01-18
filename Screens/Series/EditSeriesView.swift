//
//  EditSeriesView.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 15/01/2026.
//

import Foundation
import SwiftUI

struct EditSeriesView: View {

    @State private var seriesName: String = ""
    @State private var selectedAuthors: [Author] = []

    @Environment(\.dismiss) private var dismiss

    @FocusState private var isNameFieldFocused: Bool

    var onSave: (Series) -> Void

    var body: some View {
        NavigationView {
            VStack {
                mainForm
            }
            .navigationTitle("Add Series")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                toolBarView
            }
            .task {
                isNameFieldFocused = true
            }
        }
    }

    private var mainForm: some View {
        Form {
            Section {
                TextField("Enter series name", text: $seriesName)
                    .focused($isNameFieldFocused)
            } header: {
                Text("Display Name")
                    .textCase(nil)
                    .font(.subheadline)
                    .bold()
                    .padding(.leading, -5)
            }

            authorsSection
        }
    }

    private var authorsSection: some View {
        Section {
            NavigationLink {
                AuthorsView(selectedAuthors: $selectedAuthors)
            } label: {
                Text(selectedAuthors.isEmpty
                     ? "Necessary to add author" : filteredAuthorsString()
                )
            }
        } header: {
            Text("Author")
                .textCase(nil)
                .font(.subheadline)
                .bold()
                .padding(.leading, -5)
        }
    }

    private var toolBarView: some ToolbarContent {
        Group {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }

            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    let newSeries = Series(name: seriesName, authors: selectedAuthors)

                    onSave(newSeries)
                    dismiss()
                }
                .disabled(seriesName.isEmpty || selectedAuthors.isEmpty)
            }
        }
    }

    //TODO: Move out of here
    func filteredAuthorsString() -> String {
        selectedAuthors
        .sorted { $0.displayName.localizedCaseInsensitiveCompare($1.displayName) == .orderedAscending }
        .map(\.displayName)
        .joined(separator: ", ")
    }
}
