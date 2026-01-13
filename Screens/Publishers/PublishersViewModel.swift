//
//  PublishersViewModel.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 13/01/2026.
//

import Foundation

@Observable
final class PublishersViewModel {

    private var publishersStorage: PublishersStorage
    var publishers: [Publisher]
    var selectedPublisher: Publisher?

    init(publishersStorage: PublishersStorage = CDStorage.shared, selectedPublisher: Publisher?) {
        self.publishersStorage = publishersStorage
        self.selectedPublisher = selectedPublisher
        self.publishers = publishersStorage
            .getPublishers()
            .sorted {
                $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
            }
    }

    func removePublisher(id: UUID) {
        do {
            try self.publishersStorage.deletePublisher(id)
        } catch {
            print("Failed to delete publisher: \(error)")
        }

        reloadPublishers()
    }

    func reloadPublishers() {
        self.publishers = publishersStorage
            .getPublishers()
            .sorted {
                $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
            }
    }
}
