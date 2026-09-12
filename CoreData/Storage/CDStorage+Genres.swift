//
//  CDStorage+Genres.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 04/01/2026.
//

import Foundation
import CoreData

extension CDStorage {

    func fetchGenres() -> [CDGenre] {
        let request = CDGenre.fetchRequest()

        do {
            return try container.viewContext.fetch(request)
        } catch {
            print("Error fetching genres: \(error)")
            return []
        }
    }

    func fetchGenre(name: String) throws -> CDGenre {
        let request = CDGenre.fetchRequest()
            .filteredByName(name)

        let results = try container.viewContext.fetch(request)
        guard let genre = results.first else {
            throw CoreDataError.genreNotFound
        }

        return genre
    }

    @discardableResult
    func saveGenre(name: String) throws -> CDGenre {
        let genre = CDGenre(context: container.viewContext)
        genre.name = name

        try saveData()

        return genre
    }

    func fetchOrSaveGenre(_ genre: Genre) throws -> CDGenre {
        do {
            return try fetchGenre(name: genre.name)
        } catch CoreDataError.genreNotFound {
            return try self.saveGenre(name: genre.name)
        }
    }

    func fetchOrCreateGenre(
        name: String,
        context: NSManagedObjectContext
    ) -> CDGenre {
        let request = CDGenre.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", name)

        if let existing = try? context.fetch(request).first {
            return existing
        }

        let genre = CDGenre(context: context)
        genre.name = name
        return genre
    }
}
