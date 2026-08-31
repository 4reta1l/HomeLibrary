//
//  OpenLibraryBookLookupServiceTests.swift
//  HomeLibraryTests
//

import Testing
import Foundation
@testable import HomeLibrary

@Suite(.serialized)
struct OpenLibraryBookLookupServiceTests {

    @Test func lookup_decodesMatchingBookIntoResult() async throws {
        let isbn = "9780441013593"
        let json = """
        {
            "ISBN:\(isbn)": {
                "title": "Dune",
                "authors": [{ "name": "Frank Herbert" }],
                "publishers": [{ "name": "Ace Books" }],
                "publish_date": "1990",
                "number_of_pages": 412,
                "subjects": [{ "name": "Science Fiction" }, { "name": "Adventure" }]
            }
        }
        """
        let service = makeService(jsonResponse: json)

        let result = try await service.lookup(isbn: isbn)

        #expect(result.title == "Dune")
        #expect(result.authors == ["Frank Herbert"])
        #expect(result.publisher == "Ace Books")
        #expect(result.year == 1990)
        #expect(result.pages == 412)
        #expect(result.genres == ["Science Fiction", "Adventure"])
    }

    @Test func lookup_throwsNotFoundWhenBibKeyMissing() async throws {
        let service = makeService(jsonResponse: "{}")

        await #expect(throws: BookLookupError.notFound) {
            try await service.lookup(isbn: "0000000000")
        }
    }

    @Test func lookup_throwsInvalidISBNForBlankInput() async throws {
        let service = makeService(jsonResponse: "{}")

        await #expect(throws: BookLookupError.invalidISBN) {
            try await service.lookup(isbn: "   ")
        }
    }

    @Test func lookup_throwsDecodingErrorForMalformedJSON() async throws {
        let service = makeService(jsonResponse: "not json")

        await #expect(throws: BookLookupError.decoding) {
            try await service.lookup(isbn: "9780441013593")
        }
    }

    @Test func lookup_throwsNetworkErrorOnTransportFailure() async throws {
        StubURLProtocol.stubHandler = nil
        StubURLProtocol.stubError = URLError(.notConnectedToInternet)
        defer { StubURLProtocol.stubError = nil }

        let service = await OpenLibraryBookLookupService(urlSession: StubURLProtocol.makeSession())

        await #expect(throws: BookLookupError.network) {
            try await service.lookup(isbn: "9780441013593")
        }
    }

    private func makeService(jsonResponse: String) -> OpenLibraryBookLookupService {
        StubURLProtocol.stubError = nil
        StubURLProtocol.stubHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (jsonResponse.data(using: .utf8)!, response)
        }

        return OpenLibraryBookLookupService(urlSession: StubURLProtocol.makeSession())
    }
}
