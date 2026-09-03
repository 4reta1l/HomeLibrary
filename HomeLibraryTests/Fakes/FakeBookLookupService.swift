//
//  FakeBookLookupService.swift
//  HomeLibraryTests
//

@testable import HomeLibrary

final class FakeBookLookupService: BookLookupService {

    private let result: Result<BookLookupResult, Error>

    init(result: Result<BookLookupResult, Error> = .failure(BookLookupError.notFound)) {
        self.result = result
    }

    func lookup(isbn: String) async throws -> BookLookupResult {
        try result.get()
    }
}
