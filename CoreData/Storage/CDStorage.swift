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

    // Loading the same .xcdatamodeld into more than one NSManagedObjectModel instance makes
    // +entity resolution for CDBook/CDGenre/etc. ambiguous across instances. Every CDStorage
    // (the shared one and any ad-hoc ones tests create) must share this single instance.
    private static let managedObjectModel: NSManagedObjectModel = {
        guard let model = NSManagedObjectModel.mergedModel(from: nil) else {
            fatalError("Failed to load HomeLibrary Core Data model")
        }
        return model
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "HomeLibrary", managedObjectModel: Self.managedObjectModel)

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
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    func saveData(_ context: NSManagedObjectContext? = nil) throws {
        let context = context ?? container.viewContext
        try context.save()
    }
}
