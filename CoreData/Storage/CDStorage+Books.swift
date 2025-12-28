//
//  CDStorage+Books.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 26/12/2025.
//

import Foundation
import CoreData

extension CDStorage {

    func fetchBooks() -> [CDBook] {
        do {
            return try container.viewContext.fetch(CDBook.fetchRequest())
        } catch {
            print("Error fetching books \(error)")
            return []
        }
    }

    func saveBook(
        title: String,
        author: String,
        year: Int32,
        notes: String,
        rawStatus: String,
        isbn: String,
        pages: Int32
    ) throws {
        let newBook = CDBook(context: container.viewContext)
        newBook.id = UUID()
        newBook.title = title
        newBook.author = author
        newBook.year = year
        newBook.notes = notes
        newBook.rawStatus = rawStatus
        newBook.isbn = isbn
        newBook.pages = pages

        self.saveData()
    }

    func updateBook(
        id: UUID,
        title: String,
        author: String,
        year: Int32,
        notes: String,
        rawStatus: String,
        isbn: String,
        pages: Int32
    ) throws {
        let request = CDBook.fetchRequest()
            .filteredById(id)

        let results = try container.viewContext.fetch(request)

        if let existingBook = results.first {
            existingBook.id = id
            existingBook.title = title
            existingBook.author = author
            existingBook.year = year
            existingBook.notes = notes
            existingBook.rawStatus = rawStatus
            existingBook.isbn = isbn
            existingBook.pages = pages

            self.saveData()
        }
    }

    func deleteBook(id: UUID) throws {
        let request = CDBook.fetchRequest()
            .filteredById(id)

        let results = try container.viewContext.fetch(request)

        if let deletingBook = results.first {
            container.viewContext.delete(deletingBook)
            saveData()
        }
    }

}
