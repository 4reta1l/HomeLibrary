//
//  CDSeries.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 15/01/2026.
//

import Foundation
import CoreData

@objc(CDSeries)
final class CDSeries: NSManagedObject {

    static let entityName = "CDSeries"

    @NSManaged var id: UUID
    @NSManaged var name: String

    @NSManaged var books: Set<CDBook>
    @NSManaged var authors: Set<CDAuthor>
}

extension CDSeries {
    @nonobjc
    class func fetchRequest() -> NSFetchRequest<CDSeries> {
        NSFetchRequest<CDSeries>(entityName: entityName)
    }
}
