//
//  FakeGenresStorage.swift
//  HomeLibraryTests
//

@testable import HomeLibrary

final class FakeGenresStorage: GenresStorage {

    private(set) var genres: [Genre]

    init(genres: [Genre] = []) {
        self.genres = genres
    }

    func getGenres() -> [Genre] {
        genres
    }

    func addGenre(name: String) {
        genres.append(Genre(name: name))
    }
}
