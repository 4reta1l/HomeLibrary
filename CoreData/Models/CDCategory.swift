//
//  CDCategory.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 16/01/2026.
//

import Foundation
import CoreData

@objc(CDCategory)
final class CDCategory: NSManagedObject {

    static let entityName = "CDCategory"

    @NSManaged var id: UUID
    @NSManaged var name: String

    @NSManaged var books: Set<CDBook>
}
