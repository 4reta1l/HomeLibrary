//
//  CDStorage+Category.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 16/01/2026.
//

import Foundation
import CoreData

extension CDStorage {

    func fetchCategory() -> [CDCategory] {
        let request = CDCategory.fetchRequest()

        do {
            return try container.viewContext.fetch(request)
        } catch {
            print("Error fetching series: \(error)")
            return []
        }
    }
}
