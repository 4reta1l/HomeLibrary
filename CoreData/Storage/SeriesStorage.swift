//
//  SeriesStorage.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 15/01/2026.
//

import Foundation

public protocol SeriesStorage {

    func getSeries() -> [Publisher]

    func deleteSeries(_ id: UUID) throws
}
