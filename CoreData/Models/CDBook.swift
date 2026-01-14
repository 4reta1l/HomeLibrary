//
//  CDBook.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 26/12/2025.
//

import Foundation
import CoreData

@objc(CDBook)
final class CDBook: NSManagedObject {

    static let entityName = "CDBook"

    @NSManaged var id: UUID
    @NSManaged var title: String
    @NSManaged var rawStatus: String

    @NSManaged var notes: String?
    @NSManaged var isbn: String?

    @NSManaged var pages: NSNumber?
    @NSManaged var year: NSNumber?

    @NSManaged var authors: Set<CDAuthor>
    @NSManaged var genres: Set<CDGenre>
    @NSManaged var publisher: CDPublisher?
}

extension CDBook {
    @nonobjc class func fetchRequest() -> NSFetchRequest<CDBook> {
        NSFetchRequest<CDBook>(entityName: entityName)
    }
}
