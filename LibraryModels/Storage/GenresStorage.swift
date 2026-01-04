//
//  GenresStorage.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 04/01/2026.
//

import Foundation

public protocol GenresStorage {

    func getGenres() -> [Genre]

    func addGenre(name: String)
}
