//
//  GenresViewModel.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 04/01/2026.
//

import Foundation

@Observable
final class GenresViewModel {

    private let genresStorage: GenresStorage
    var allgenres: [Genre]

    init(genresStorage: GenresStorage = CDStorage.shared) {
        self.genresStorage = genresStorage
        self.allgenres = CDStorage.shared.getGenres()
            .sorted {
                $0.name < $1.name
            }
    }
}
