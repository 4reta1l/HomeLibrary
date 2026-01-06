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

    init(authorsStorage: AuthorsStorage = CDStorage.shared) {
        self.authorsStorage = authorsStorage
        self.authors = authorsStorage.getAuthors()
    }

    func reloadAuthors() {
        self.authors = authorsStorage.getAuthors()
    }
}
