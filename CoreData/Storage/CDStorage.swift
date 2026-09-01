//
//  CDStorage.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 22/12/2025.
//

import Foundation
import CoreData

final class CDStorage: BooksStorage, AuthorsStorage, GenresStorage, PublishersStorage, SeriesStorage, CategoriesStorage {

    public static let shared = CDStorage()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "HomeLibrary")

        if inMemory {
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            description.shouldAddStoreAsynchronously = false
            container.persistentStoreDescriptions = [description]
        }

        container.loadPersistentStores { _, error in
            if let error {
                assertionFailure("Failed to load Core Data stack: \(error)")
            }
        }
    }

    func saveData(_ context: NSManagedObjectContext? = nil) {
        let context = context ?? container.viewContext

        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            print("Error while saving \(nserror), \(nserror.userInfo)")
        }
    }
}
