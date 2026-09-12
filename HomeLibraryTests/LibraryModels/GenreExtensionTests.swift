//
//  GenreExtensionTests.swift
//  HomeLibraryTests
//

import Testing
import Foundation
@testable import HomeLibrary

struct GenreExtensionTests {

    @Test func displayJoinedNames_sortsGenresAlphabetically() {
        let genres = [
            Genre(name: "Thriller"),
            Genre(name: "Adventure"),
            Genre(name: "Fantasy")
        ]

        #expect(genres.displayJoinedNames == "Adventure, Fantasy, Thriller")
    }

    @Test func displayJoinedNames_returnsEmptyStringForEmptyArray() {
        let genres: [Genre] = []

        #expect(genres.displayJoinedNames == "")
    }
}
