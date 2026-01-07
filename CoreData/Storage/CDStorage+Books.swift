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
        authors: Set<CDAuthor>,
        notes: String?,
        rawStatus: String,
        isbn: String?,
        pages: NSNumber?,
        year: NSNumber?,
        genres: Set<CDGenre>
    ) throws {
        let newBook = CDBook(context: container.viewContext)
        newBook.id = UUID()
        newBook.title = title
        newBook.authors = authors
        newBook.notes = notes
        newBook.rawStatus = rawStatus
        newBook.isbn = isbn
        newBook.pages = pages
        newBook.year = year
        newBook.genres = genres

        self.saveData()
    }

    func updateBook(
        id: UUID,
        title: String,
        authors: Set<CDAuthor>,
        notes: String?,
        rawStatus: String,
        isbn: String?,
        pages: NSNumber?,
        year: NSNumber?,
        genres: Set<CDGenre>
    ) throws {
        let request = CDBook.fetchRequest()
            .filteredById(id)

        let results = try container.viewContext.fetch(request)

        if let existingBook = results.first {
            existingBook.id = id
            existingBook.title = title
            existingBook.authors = authors
            existingBook.year = year
            existingBook.notes = notes
            existingBook.rawStatus = rawStatus
            existingBook.isbn = isbn
            existingBook.pages = pages
            existingBook.genres = genres

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

        //TODO: check whether it is last book for authors, if so, delete them
    }

}
