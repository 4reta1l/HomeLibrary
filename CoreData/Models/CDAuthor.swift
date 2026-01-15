//
//  CDAuthor.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 05/01/2026.
//

import Foundation
import CoreData

@objc(CDAuthor)
final class CDAuthor: NSManagedObject {

    static let entityName = "CDAuthor"

    @NSManaged var id: UUID
    @NSManaged var displayName: String

    @NSManaged var books: Set<CDBook>
    @NSManaged var series: Set<CDSeries>
}

extension CDAuthor {
    @nonobjc
    class func fetchRequest() -> NSFetchRequest<CDAuthor> {
        NSFetchRequest<CDAuthor>(entityName: entityName)
    }
}
