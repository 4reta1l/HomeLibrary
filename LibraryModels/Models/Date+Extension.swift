//
//  Date+Extension.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 18/12/2025.
//

import Foundation

extension Date {
    var year: Int {
        Calendar.current.component(.year, from: self)
    }
}
