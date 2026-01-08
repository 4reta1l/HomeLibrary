//
//  AuthorsStorage.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 05/01/2026.
//

import Foundation

public protocol AuthorsStorage {

    func getAuthors() -> [Author]

    func deleteAuthor(_ id: UUID) throws
}
