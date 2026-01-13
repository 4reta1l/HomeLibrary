//
//  PublishersStorage.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 13/01/2026.
//

import Foundation

public protocol PublishersStorage {

    func deletePublisher(_ id: UUID) throws
}
