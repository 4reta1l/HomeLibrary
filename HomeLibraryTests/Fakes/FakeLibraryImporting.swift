//
//  FakeLibraryImporting.swift
//  HomeLibraryTests
//

import Foundation
@testable import HomeLibrary

final class FakeLibraryImporting: LibraryImporting {

    private(set) var importedURLs: [URL] = []

    func importBooks(from url: URL) throws {
        importedURLs.append(url)
    }
}
