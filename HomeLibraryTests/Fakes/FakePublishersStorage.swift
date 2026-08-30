//
//  FakePublishersStorage.swift
//  HomeLibraryTests
//

import Foundation
@testable import HomeLibrary

final class FakePublishersStorage: PublishersStorage {

    private(set) var publishers: [Publisher]
    private(set) var deletedPublisherIds: [UUID] = []

    init(publishers: [Publisher] = []) {
        self.publishers = publishers
    }

    func getPublishers() -> [Publisher] {
        publishers
    }

    func deletePublisher(_ id: UUID) throws {
        deletedPublisherIds.append(id)
        publishers.removeAll { $0.id == id }
    }
}
