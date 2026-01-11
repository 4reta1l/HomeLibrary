//
//  Set+Extension.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 11/01/2026.
//

import Foundation

extension Set {
    mutating func toggle(_ element: Element) {
        if contains(element) {
            remove(element)
        } else {
            insert(element)
        }
    }
}
