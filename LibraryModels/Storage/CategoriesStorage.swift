//
//  CategoriesStorage.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 16/01/2026.
//

import Foundation

public protocol CategoriesStorage {

    func getCategories() -> [Category]

    func addCategory(_ category: Category)

    func editCategory(_ category: Category) throws
}
