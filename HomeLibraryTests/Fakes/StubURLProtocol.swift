//
//  StubURLProtocol.swift
//  HomeLibraryTests
//

import Foundation

final class StubURLProtocol: URLProtocol {

    static var stubHandler: ((URLRequest) -> (Data, HTTPURLResponse))?
    static var stubError: Error?

    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        if let error = Self.stubError {
            client?.urlProtocol(self, didFailWithError: error)
            return
        }

        guard let handler = Self.stubHandler else {
            fatalError("StubURLProtocol.stubHandler not set")
        }

        let (data, response) = handler(request)
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: data)
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}

    static func makeSession() -> URLSession {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [StubURLProtocol.self]
        return URLSession(configuration: configuration)
    }
}
