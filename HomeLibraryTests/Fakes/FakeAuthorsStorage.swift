//
//  FakeAuthorsStorage.swift
//  HomeLibraryTests
//

import Foundation
@testable import HomeLibrary

final class FakeAuthorsStorage: AuthorsStorage {

    private(set) var authors: [Author]
    private(set) var deletedAuthorIds: [UUID] = []

    init(authors: [Author] = []) {
        self.authors = authors
    }

    func getAuthors() -> [Author] {
        authors
    }

    func deleteAuthor(_ id: UUID) throws {
        deletedAuthorIds.append(id)
        authors.removeAll { $0.id == id }
    }
}
