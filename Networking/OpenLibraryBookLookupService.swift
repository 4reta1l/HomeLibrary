//
//  OpenLibraryBookLookupService.swift
//  HomeLibrary
//

import Foundation

final class OpenLibraryBookLookupService: BookLookupService {

    private let urlSession: URLSession
    private let baseURL: URL

    init(
        urlSession: URLSession = .shared,
        baseURL: URL = URL(string: "https://openlibrary.org/api/books")!
    ) {
        self.urlSession = urlSession
        self.baseURL = baseURL
    }

    func lookup(isbn: String) async throws -> BookLookupResult {
        let sanitizedISBN = isbn.filter { $0.isNumber || $0 == "X" || $0 == "x" }

        guard !sanitizedISBN.isEmpty else {
            throw BookLookupError.invalidISBN
        }

        let bibKey = "ISBN:\(sanitizedISBN)"

        guard var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false) else {
            throw BookLookupError.invalidISBN
        }
        components.queryItems = [
            URLQueryItem(name: "bibkeys", value: bibKey),
            URLQueryItem(name: "jscmd", value: "data"),
            URLQueryItem(name: "format", value: "json")
        ]

        guard let url = components.url else {
            throw BookLookupError.invalidISBN
        }

        let data: Data
        do {
            (data, _) = try await urlSession.data(from: url)
        } catch {
            throw BookLookupError.network
        }

        let decoded: [String: OpenLibraryBookResponse]
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoded = try decoder.decode([String: OpenLibraryBookResponse].self, from: data)
        } catch {
            throw BookLookupError.decoding
        }

        guard let response = decoded[bibKey] else {
            throw BookLookupError.notFound
        }

        return BookLookupResult(
            title: response.title,
            authors: response.authors?.map(\.name) ?? [],
            publisher: response.publishers?.first?.name,
            year: response.publishDate.flatMap(Self.extractYear),
            pages: response.numberOfPages,
            genres: Array((response.subjects ?? []).prefix(3).map(\.name))
        )
    }

    private static func extractYear(from dateString: String) -> Int? {
        dateString
            .split(separator: " ")
            .compactMap { Int($0.filter(\.isNumber)) }
            .first { $0 > 1000 && $0 < 3000 }
    }
}

private struct OpenLibraryBookResponse: Decodable {
    let title: String?
    let authors: [OpenLibraryAuthor]?
    let publishers: [OpenLibraryPublisher]?
    let publishDate: String?
    let numberOfPages: Int?
    let subjects: [OpenLibrarySubject]?
}

private struct OpenLibraryAuthor: Decodable {
    let name: String
}

private struct OpenLibraryPublisher: Decodable {
    let name: String
}

private struct OpenLibrarySubject: Decodable {
    let name: String
}
