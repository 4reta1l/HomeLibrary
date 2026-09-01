//
//  LibraryImporting.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 01/09/2026.
//

import Foundation

public protocol LibraryImporting {

    /// Imports books from a CSV file, matching existing books by id.
    func importBooks(from url: URL) throws
}
