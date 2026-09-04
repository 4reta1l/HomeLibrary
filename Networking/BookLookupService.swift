//
//  BookLookupService.swift
//  HomeLibrary
//

import Foundation

protocol BookLookupService {
    func lookup(isbn: String) async throws -> BookLookupResult
}

nonisolated struct BookLookupResult: Equatable {
    let title: String?
    let authors: [String]
    let publisher: String?
    let year: Int?
    let pages: Int?
    let genres: [String]
}

nonisolated enum BookLookupError: Error, Equatable {
    case invalidISBN
    case notFound
    case network
    case decoding
}
