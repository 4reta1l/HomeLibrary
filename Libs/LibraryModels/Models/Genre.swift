//
//  Genre.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 12/12/2025.
//

public enum Genre: String, CaseIterable {
    case general
    case fantasy
    case horror
    case romance
    case mystery
    case memoir
    case historical
    case science
    case adventure
    case thriller
    case fairyTale
}

public extension Genre {
    var displayString: String {
        switch self {
        case .general: "General"
        case .fantasy: "Fantasy"
        case .horror: "Horror"
        case .romance: "Romance"
        case .mystery: "Mystery"
        case .memoir: "Memoir"
        case .historical: "Historical"
        case .science: "Science"
        case .adventure: "Adventure"
        case .thriller: "Thriller"
        case .fairyTale: "Fairy Tale"
        }
    }
}
