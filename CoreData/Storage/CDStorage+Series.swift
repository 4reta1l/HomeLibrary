//
//  CDStorage+Series.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 15/01/2026.
//

import Foundation
import CoreData

extension CDStorage {

    func fetchSeries() -> [CDSeries] {
        let request = CDSeries.fetchRequest()

        do {
            return try container.viewContext.fetch(request)
        } catch {
            print("Error fetching series: \(error)")
            return []
        }
    }

    func fetchSeries(id: UUID) throws -> CDSeries {
        let request = CDSeries.fetchRequest()
            .filteredById(id)

        let results = try container.viewContext.fetch(request)
        guard let series = results.first else {
            throw CoreDataError.seriesNotFound
        }

        return series
    }

    func saveSeries(
        id: UUID,
        name: String
    ) -> CDSeries {
        let newSeries = CDSeries(context: container.viewContext)
        newSeries.id = id
        newSeries.name = name

        saveData()

        return newSeries
    }

    func updateSeries(
        id: UUID,
        name: String
    ) throws {
        let request = CDSeries.fetchRequest()
            .filteredById(id)

        let results = try container.viewContext.fetch(request)
        if let seriesToUpdate = results.first {
            seriesToUpdate.id = UUID()
            seriesToUpdate.name = name

            saveData()
        }
    }

    func deleteSeries(id: UUID) throws {
        let request = CDSeries.fetchRequest()
            .filteredById(id)

        let results = try container.viewContext.fetch(request)

        if let seletingSeries = results.first {
            container.viewContext.delete(seletingSeries)
            saveData()
        }
    }
}
