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
        NavigationView {
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
        Section(header: Text("Authors")) {
            NavigationLink(destination: AuthorsFilterView(authors: authors, filters: $filters)) {
                Text(filters.selectedAuthors.isEmpty
                     ? "No selected authors" : filters.selectedAuthors.sorted { $0.displayName.localizedCaseInsensitiveCompare($1.displayName) == .orderedAscending }
                    .map(\.displayName)
                    .joined(separator: ", ")
                )
            }

            if !filters.selectedAuthors.isEmpty {
                Button {
                    withAnimation {
                        filters.selectedAuthors.removeAll()
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



    var genresSection: some View {
        Section(header: Text("Genres")) {
            NavigationLink(destination: GenresFilterView(genres: genres, filters: $filters)) {
                Text(filters.selectedGenres.isEmpty
                     ? "No selected genres" : filters.selectedGenres.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
                    .map(\.name)
                    .joined(separator: ", ")
                )
            }

            if !filters.selectedGenres.isEmpty {
                Button {
                    withAnimation {
                        filters.selectedGenres.removeAll()
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
