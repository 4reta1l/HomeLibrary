//
//  CDGenre.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 04/01/2026.
//

import Foundation
import CoreData

@objc(CDGenre)
final class CDGenre: NSManagedObject {

    static let entityName = "CDGenre"

    @NSManaged var name: String

    @NSManaged var books: Set<CDBook>
}

extension CDGenre {
    @nonobjc
    class func fetchRequest() -> NSFetchRequest<CDGenre> {
        NSFetchRequest<CDGenre>(entityName: entityName)
    }
}
