//
//  GenresView.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 04/01/2026.
//

import Foundation
import SwiftUI

struct GenresView: View {

    @Binding var selectedGenres: [Genre]

    let allGenres = CDStorage.shared.getGenres()

    var body: some View {
        List {
            ForEach(allGenres, id: \.name) { genre in
                HStack {
                    Text(genre.name)

                    Spacer()

                    if selectedGenres.contains(genre) {
                        Image(systemName: "checkmark")
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    toggle(genre)
                }
            }
        }
        .navigationTitle("Select Genres")
    }

    private func toggle(_ genre: Genre) {

        if let index = selectedGenres.firstIndex(of: genre) {
            selectedGenres.remove(at: index)
        } else {
            selectedGenres.append(genre)
        }
    }
}


