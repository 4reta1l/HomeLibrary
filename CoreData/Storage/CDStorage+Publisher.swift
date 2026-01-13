//
//  CDStorage+Publisher.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 13/01/2026.
//

import Foundation
import CoreData

extension CDStorage {

    func fetchPublisher(id: UUID) throws -> CDPublisher {
        let request = CDPublisher.fetchRequest()
            .filteredById(id)

        let results = try container.viewContext.fetch(request)
        guard let author = results.first else {
            throw CoreDataError.publisherNotFound
        }

        return author
    }

    func savePublisher(id: UUID, name: String) -> CDPublisher {
        let publisher = CDPublisher(context: container.viewContext)
        publisher.id = id
        publisher.name = name

        saveData()

        return publisher
    }

    func updatePublisher(id: UUID, name: String) throws {
        let request = CDPublisher.fetchRequest()
            .filteredById(id)

        let results = try container.viewContext.fetch(request)
        if let publisher = results.first {
            publisher.id = UUID()
            publisher.name = name

            saveData()
        }
    }

    func deletePublisher(id: UUID) throws {
        let request = CDPublisher.fetchRequest()
            .filteredById(id)

        let results = try container.viewContext.fetch(request)

        if let deletingPublisher = results.first {
            container.viewContext.delete(deletingPublisher)
            saveData()
        }
    }
}
