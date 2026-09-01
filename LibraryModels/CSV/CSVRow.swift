//
//  CSVRow.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 01/09/2026.
//

import Foundation

public struct CSVRow {

    private let values: [String: String]

    public init(headers: [String], fields: [String]) {
        var values: [String: String] = [:]
        for (index, header) in headers.enumerated() where index < fields.count {
            values[header] = fields[index]
        }
        self.values = values
    }

    /// Returns nil for missing or empty columns.
    public subscript(column: String) -> String? {
        guard let value = values[column], !value.isEmpty else { return nil }
        return value
    }
}
