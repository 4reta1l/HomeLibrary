//
//  NSFetchRequest+Extension.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 26/12/2025.
//

import Foundation
import CoreData

extension NSFetchRequest {
    @objc func filteredById(_ id: UUID) -> NSFetchRequest {
        self.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        return self
    }

    @objc func filteredByName(_ name: String) -> NSFetchRequest {
        self.predicate = NSPredicate(format: "name == %@", name as CVarArg)
        return self
    }
}
