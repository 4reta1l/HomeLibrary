//
//  Book.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 12/12/2025.
//

import Foundation

public struct Book: Identifiable, Equatable, Hashable {

    public let id: UUID
    public let title: String
    public let author: String
    public let genre: Genre
    public let year: Date
    public let notes: String
    public let status: Status
    public let isbn: String
}
