//
//  CDPublisher.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 13/01/2026.
//

import Foundation
import CoreData

@objc(CDPublisher)
final class CDPublisher: NSManagedObject {

    static let entityName = "CDPublished"

    @NSManaged var id: UUID
    @NSManaged var name: String

    @NSManaged var books: Set<CDBook>
}

extension CDPublisher {
    @nonobjc
    class func fetchRequest() -> NSFetchRequest<CDPublisher> {
        NSFetchRequest<CDPublisher>(entityName: entityName)
    }
}
