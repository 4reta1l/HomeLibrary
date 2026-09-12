//
//  FiltersView.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 11/01/2026.
//

import Foundation
import SwiftUI

struct FiltersView: View {

    var authors: [Author]
    var genres: [Genre]

    @Binding var filters: BookFilters

    @Environment(\.dismiss) private var dismiss

    let yearsArray = Array(1800...Date().year)

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Form {
                    authorsSection
                    genresSection
                    yearSection
                }

                Spacer()

                Button("Clear all") {
                    filters.selectedAuthors.removeAll()
                    filters.selectedGenres.removeAll()
                    filters.selectedYear = "—"
                }
                .foregroundColor(.red)
            }
            .navigationTitle("Filters")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }

    var authorsSection: some View {
        filterSection(
            header: "Authors",
            isEmpty: filters.selectedAuthors.isEmpty,
            selectedText: Array(filters.selectedAuthors).displayJoinedNames,
            emptyText: "No selected authors",
            destination: AuthorsFilterView(authors: authors, filters: $filters),
            onClear: { filters.selectedAuthors.removeAll() }
        )
    }

    var genresSection: some View {
        filterSection(
            header: "Genres",
            isEmpty: filters.selectedGenres.isEmpty,
            selectedText: Array(filters.selectedGenres).displayJoinedNames,
            emptyText: "No selected genres",
            destination: GenresFilterView(genres: genres, filters: $filters),
            onClear: { filters.selectedGenres.removeAll() }
        )
    }

    private func filterSection<Destination: View>(
        header: String,
        isEmpty: Bool,
        selectedText: String,
        emptyText: String,
        destination: Destination,
        onClear: @escaping () -> Void
    ) -> some View {
        Section(header: Text(header)) {
            NavigationLink(destination: destination) {
                Text(isEmpty ? emptyText : selectedText)
            }

            if !isEmpty {
                Button {
                    withAnimation {
                        onClear()
                    }
                } label: {
                    HStack {
                        Spacer()
                        Text("Clear")
                            .foregroundStyle(.red)
                        Spacer()
                    }
                }
            }
        }
    }

    var yearSection: some View {
        VStack {
            Picker("Year of publication", selection: $filters.selectedYear) {
                Text("—")
                    .tag("—")
                ForEach(yearsArray.reversed(), id: \.self) { year in
                    Text(String(year))
                        .tag(String(year))
                }
            }
            if filters.selectedYear != "—" {
                Button {
                    withAnimation {
                        filters.selectedYear = "—"
                    }
                } label: {
                    HStack {
                        Spacer()
                        Text("Clear")
                            .foregroundStyle(.red)
                        Spacer()
                    }
                }
                .buttonStyle(.plain)
            }
        }
    }
}
