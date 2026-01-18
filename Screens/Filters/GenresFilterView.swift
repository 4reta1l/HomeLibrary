//
//  GenresFilterView.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 11/01/2026.
//

import Foundation
import SwiftUI

struct GenresFilterView: View {

    var genres: [Genre]

    @Binding var filters: BookFilters

    var body: some View {
        Form {
            Section(header: Text("Genres")) {
                ForEach(sortedGenres, id: \.name) { genre in
                    Button {
                        filters.selectedGenres.toggle(genre)
                    } label: {
                        HStack {
                            Text(genre.name)
                            Spacer()
                            if filters.selectedGenres.contains(genre) {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            }
        }
    }

    var sortedGenres: [Genre] {
        genres
            .sorted {
                $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
            }
    }
}
