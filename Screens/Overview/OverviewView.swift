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
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {

                    readingProgressSection
                    totalsSection
                    recommendationsSection

                }
                .padding()
            }
            .navigationTitle("Overview")
        }
    }

    private var readingProgressSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Reading status")

            ReadingStatusProgress(
                status: .unread,
                count: unreadCount,
                total: store.books.count
            )

            ReadingStatusProgress(
                status: .reading,
                count: readingCount,
                total: store.books.count
            )

            ReadingStatusProgress(
                status: .completed,
                count: completedCount,
                total: store.books.count
            )
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
    }

    private var totalsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Library summary")

            HStack {
                StatItem(title: "Books", value: store.books.count)
                Spacer()
                StatItem(title: "Categories", value: store.categories.count)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
    }

    private var recommendationsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Recommendations")

            if !currentlyReading.isEmpty {
                recommendationSection(
                    title: "Continue reading",
                    books: currentlyReading
                )
            }

            if !recommendedUnread.isEmpty {
                recommendationSection(
                    title: "Based on your library",
                    books: recommendedUnread
                )
            }
        }
    }

    private func recommendationSection(
        title: String,
        books: [Book]
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {

            Text(title)
                .font(.headline)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(books.prefix(5), id: \.id) { book in
                        BookRecommendationCard(book: book)
                    }
                }
                .padding(.vertical, 4)
            }
        }
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.title3)
            .bold()
    }
}

struct StatItem: View {

    let title: String
    let value: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)

            Text("\(value)")
                .font(.title2)
                .bold()
        }
    }
}

struct BookRecommendationCard: View {

    let book: Book

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {

            Text(book.title)
                .font(.headline)
                .lineLimit(2)

            Text(book.authors.map(\.displayName).joined(separator: ", "))
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(1)

            Spacer(minLength: 0)
        }
        .padding()
        .frame(width: 160, height: 120)
        .background(Color(.systemBackground))
        .cornerRadius(14)
        .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
    }
}

private extension OverviewView {

    var currentlyReading: [Book] {
        store.books.filter { $0.status == .reading }
    }

    var recommendedUnread: [Book] {
        store.books.filter { $0.status == .unread }
    }

    var unreadCount: Int {
        store.books.filter { $0.status == .unread }.count
    }

    var readingCount: Int {
        store.books.filter { $0.status == .reading }.count
    }

    var completedCount: Int {
        store.books.filter { $0.status == .completed }.count
    }
}

