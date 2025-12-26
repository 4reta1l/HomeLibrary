//
//  CDBook.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 24/12/2025.
//

import Foundation
import CoreData

final class CDBook: NSManagedObject {

    static let entityName = "CDBook"

    @NSManaged var id: UUID
    @NSManaged var title: String
    @NSManaged var author: String
    @NSManaged var year: Int32
    @NSManaged var notes: String
    @NSManaged var status: String
    @NSManaged var isbn: String
    @NSManaged var pages: Int32
}
