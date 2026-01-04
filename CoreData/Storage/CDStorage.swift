//
//  CDStorage.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 22/12/2025.
//

import Foundation
import CoreData

final class CDStorage: BooksStorage, GenresStorage {

    public static let shared = CDStorage()

    let container: NSPersistentContainer

    private init() {
        container = NSPersistentContainer(name: "HomeLibrary")

        container.loadPersistentStores { _, error in
            if let error {
                print("Error loading core data \(error)")
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
