//
//  CSVParserTests.swift
//  HomeLibraryTests
//
//  Created by Maksym Pyvovarov on 01/09/2026.
//

import Testing
@testable import HomeLibrary

struct CSVParserTests {

    private let sut = CSVParser()

    @Test("Splits a plain row on commas")
    func plainRow() throws {
        #expect(try sut.parse("a,b,c") == [["a", "b", "c"]])
    }

    @Test("A quoted field keeps its comma")
    func quotedComma() throws {
        #expect(try sut.parse("\"Hello, World\",b") == [["Hello, World", "b"]])
    }

    @Test("Escaped quotes survive parsing")
    func escapedQuotes() throws {
        let rows = try sut.parse("\"He said \"\"hi\"\"\",b")
        #expect(rows == [["He said \"hi\"", "b"]])
    }

    @Test("A newline inside a quoted field does not start a new row")
    func quotedNewline() throws {
        let rows = try sut.parse("1,\"line one\nline two\",3")
        #expect(rows.count == 1)
        #expect(rows[0][1] == "line one\nline two")
    }

    @Test("Trailing newline does not produce a phantom row")
    func trailingNewline() throws {
        #expect(try sut.parse("a,b\n").count == 1)
    }

    @Test("An unterminated quote is reported, not silently truncated")
    func unterminatedQuote() {
        #expect(throws: CSVParser.ParseError.unterminatedQuote) {
            try sut.parse("\"oops")
        }
    }
}
