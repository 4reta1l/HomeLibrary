//
//  CDStorage+Authors.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 05/01/2026.
//

import Foundation
import CoreData

extension CDStorage {

    func fetchAuthors() -> [CDAuthor] {
        let request = CDAuthor.fetchRequest()

        do {
            return try container.viewContext.fetch(request)
        } catch {
            print("Error fetching authors")
            return []
        }
    }

    func fetchAuthor(id: UUID) throws -> CDAuthor {
        let request = CDAuthor.fetchRequest()
            .filteredById(id)

        let results = try container.viewContext.fetch(request)
        guard let author = results.first else {
            throw CoreDataError.authorNotFound
        }

        return author
    }

    func saveAuthor(id: UUID, displayName: String) -> CDAuthor {
        let author = CDAuthor(context: container.viewContext)
        author.id = id
        author.displayName = displayName

        saveData()

        return author
    }

    func updateAuthor(id: UUID, displayName: String) throws {
        let request = CDAuthor.fetchRequest()
            .filteredById(id)

        let results = try container.viewContext.fetch(request)
        if let author = results.first {
            author.id = UUID()
            author.displayName = displayName

            saveData()
        }
    }
}
