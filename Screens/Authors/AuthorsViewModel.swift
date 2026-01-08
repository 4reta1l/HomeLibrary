//
//  AuthorsViewModel.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 06/01/2026.
//

import Foundation

@Observable
final class AuthorsViewModel {

    private var authorsStorage: AuthorsStorage
    var authors: [Author]
    var selectedAuthors: [Author]

    init(authorsStorage: AuthorsStorage = CDStorage.shared, selectedAuthors: [Author]) {
        self.authorsStorage = authorsStorage
        self.authors = authorsStorage.getAuthors()
        self.selectedAuthors = selectedAuthors

        mergeSelectedAuthors()

        self.authors.sort {
            $0.displayName.localizedCaseInsensitiveCompare($1.displayName) == .orderedAscending
        }

    }

    func removeAuthor(id: UUID) {
        do {
            try self.authorsStorage.deleteAuthor(id)
        } catch {
            print("Failed to delete author: \(error)")
        }

        reloadAuthors()
    }

    func reloadAuthors() {
        self.authors = authorsStorage.getAuthors()
    }

    func mergeSelectedAuthors() {
        for author in selectedAuthors where !authors.contains(author) {
            authors.append(author)
        }
    }

}
