//
//  SeriesStorage.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 15/01/2026.
//

import Foundation

public protocol SeriesStorage {

    func getSeries() -> [Series]

    func deleteSeries(_ id: UUID) throws
}
