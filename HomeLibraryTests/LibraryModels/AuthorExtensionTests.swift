//
//  AuthorExtensionTests.swift
//  HomeLibraryTests
//

import Testing
import Foundation
@testable import HomeLibrary

struct AuthorExtensionTests {

    @Test func displayJoinedNames_sortsAuthorsAlphabetically() {
        let authors = [
            Author(displayName: "Ursula K. Le Guin"),
            Author(displayName: "Isaac Asimov"),
            Author(displayName: "Frank Herbert")
        ]

        #expect(authors.displayJoinedNames == "Frank Herbert, Isaac Asimov, Ursula K. Le Guin")
    }

    @Test func displayJoinedNames_returnsEmptyStringForEmptyArray() {
        let authors: [Author] = []

        #expect(authors.displayJoinedNames == "")
    }
}
