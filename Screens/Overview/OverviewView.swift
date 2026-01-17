//
//  OverviewView.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 17/01/2026.
//

import SwiftUI

struct OverviewView: View {

    @Environment(LibraryStore.self) private var store

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Reading Status")
                        .font(.title3)
                        .bold()

                    ReadingStatusProgress(status: .unread, count: store.books.filter { $0.status == .unread }.count, total: store.books.count)
                    ReadingStatusProgress(status: .reading, count: store.books.filter { $0.status == .reading }.count, total: store.books.count)
                    ReadingStatusProgress(status: .completed, count: store.books.filter { $0.status == .completed }.count, total: store.books.count)
                }
                .padding()

                VStack(alignment: .leading) {
                    Text("Total number of books: \(store.books.count)")
                        .font(.headline)
                    Text("Total number of categories: \(store.categories.count)")
                        .font(.headline)
                }
                .padding(.top, -10)

                Spacer()
            }
            .navigationTitle("Overview")
        }
    }
}
