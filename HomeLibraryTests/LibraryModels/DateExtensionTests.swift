//
//  DateExtensionTests.swift
//  HomeLibraryTests
//

import Testing
import Foundation
@testable import HomeLibrary

struct DateExtensionTests {

    @Test func year_returnsCalendarYearComponent() {
        var components = DateComponents()
        components.year = 1965
        components.month = 6
        components.day = 1
        let date = Calendar.current.date(from: components)!

        #expect(date.year == 1965)
    }
}
