//
//  BookExtensionTests.swift
//  HomeLibraryTests
//

import Testing
import Foundation
@testable import HomeLibrary

struct BookExtensionTests {

    @Test func displayNotes_returnsEmptyStringForNilOrEmptyNotes() {
        #expect(makeBook(notes: nil).displayNotes == "")
        #expect(makeBook(notes: "").displayNotes == "")
    }

    @Test func displayNotes_returnsNotesWhenPresent() {
        #expect(makeBook(notes: "Loved it").displayNotes == "Loved it")
    }

    @Test func displayISBN_returnsEmptyStringForNilOrEmptyISBN() {
        #expect(makeBook(isbn: nil).displayISBN == "")
        #expect(makeBook(isbn: "").displayISBN == "")
    }

    @Test func displayISBN_returnsISBNWhenPresent() {
        #expect(makeBook(isbn: "9780441013593").displayISBN == "9780441013593")
    }

    @Test func displayPages_showsEmDashWhenNil() {
        #expect(makeBook(pages: nil).displayPages == "—")
    }

    @Test func displayPages_showsNumberWhenPresent() {
        #expect(makeBook(pages: 412).displayPages == "412")
    }

    @Test func displayPagesForEdit_showsEmptyStringWhenNil() {
        #expect(makeBook(pages: nil).displayPagesForEdit == "")
    }

    @Test func displayPagesForEdit_showsNumberWhenPresent() {
        #expect(makeBook(pages: 412).displayPagesForEdit == "412")
    }

    @Test func displayYear_showsEmDashWhenNil() {
        #expect(makeBook(year: nil).displayYear == "—")
    }

    @Test func displayYear_showsYearWhenPresent() {
        #expect(makeBook(year: 1965).displayYear == "1965")
    }

    private func makeBook(
        notes: String? = nil,
        isbn: String? = nil,
        pages: Int? = nil,
        year: Int? = nil
    ) -> Book {
        Book(
            id: UUID(),
            title: "Dune",
            authors: [],
            genres: [],
            notes: notes,
            status: .unread,
            isbn: isbn,
            pages: pages,
            year: year,
            series: nil,
            category: Category(name: "Owned")
        )
    }
}
