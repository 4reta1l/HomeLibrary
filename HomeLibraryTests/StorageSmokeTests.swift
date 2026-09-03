//
//  StorageSmokeTests.swift
//  HomeLibraryTests
//
//  Created by Maksym Pyvovarov on 01/09/2026.
//

import Testing
import Foundation
@testable import HomeLibrary

struct StorageSmokeTests {

    @Test("A fresh in-memory store starts empty")
    func freshStoreIsEmpty() {
        let sut = CDStorage(inMemory: true)
        #expect(sut.getBooks().isEmpty)
    }

    @Test("Each instance gets its own store")
    func storesAreIsolated() throws {
        let first = CDStorage(inMemory: true)
        let second = CDStorage(inMemory: true)

        first.addCategory(Category(name: "Owned"))

        #expect(first.getCategories().count == 1)
        #expect(second.getCategories().isEmpty)
    }
}
