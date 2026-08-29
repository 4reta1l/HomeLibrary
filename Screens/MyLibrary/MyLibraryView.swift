//
//  MyLibraryView.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 12/12/2025.
//

import SwiftUI

struct MyLibraryView: View {

    enum ViewState: Equatable {
        case defaultView
        case forCategory(category: Category)
    }

    @State private var viewModel: MyLibraryViewModel
    @Environment(LibraryStore.self) private var store
    @State private var state: ViewState

    @State private var showAddBook: Bool = false
    @State private var tappedBook: Book?
    @State private var showFilters: Bool = false
    @State private var showSettings: Bool = false

    init(state: ViewState) {
        _viewModel = State(initialValue: MyLibraryViewModel(state: state))
        self.state = state
    }

    private var filteredBooks: [Book] {
        viewModel.filteredBooks(from: store.books)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                booksAmount
                    .padding(.vertical, 8)

                if filteredBooks.isEmpty {
                    emptyState
                } else {
                    ZStack(alignment: .bottom) {
                        List {
                            ForEach(filteredBooks) { book in
                                bookRowView(book)
                            }
                            Color.clear
                                .frame(height: 80)
                                .listRowSeparator(.hidden)
                        }
                        .listStyle(.plain)

                        addBookButton
                    }
                }
            }
            .navigationTitle("My Library")
            .searchable(
                text: $viewModel.searchText,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "Search for a book"
            )
            .toolbar {
                filtersToolBar
                settingsToolBar
            }
            .sheet(item: $tappedBook) { book in
                EditBookView(state: .editBook(book: book))
            }
            .sheet(isPresented: $showAddBook) {
                let category: Category = {
                    if case .forCategory(let cat) = state { return cat }
                    return .default
                }()
                EditBookView(state: .addBook(category: category))
            }
            .sheet(isPresented: $showSettings, onDismiss: store.reloadAll) {
                SettingsView()
            }
            .popover(isPresented: $showFilters, arrowEdge: .top) {
                FiltersView(authors: store.authors, genres: store.genres, filters: $viewModel.filters)
            }
        }
    }

    // MARK: - Subviews

    private var booksAmount: some View {
        let count = filteredBooks.count
        return Text(count == 1 ? "1 book" : "\(count) books")
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
    }

    private var emptyState: some View {
        ContentUnavailableView(
            viewModel.searchText.isEmpty ? "No Books Yet" : "No Results",
            systemImage: viewModel.searchText.isEmpty ? "books.vertical" : "magnifyingglass",
            description: Text(
                viewModel.searchText.isEmpty
                ? "Tap \"Add book\" to start your library."
                : "Try a different search or clear your filters."
            )
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var filtersToolBar: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                showFilters.toggle()
            } label: {
                RoundedRectangle(cornerRadius: 6)
                    .frame(width: 28, height: 28)
                    .overlay {
                        Image(systemName: "line.3.horizontal.decrease")
                            .font(.system(size: 12, weight: .semibold))
                    }

                Text("Filters")
                    .font(.caption)
                    .foregroundColor(.primary)
            }
        }
    }

    private var settingsToolBar: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button {
                showSettings.toggle()
            } label: {
                Label("Settings", systemImage: "gear")
            }
        }
    }

    private func bookRowView(_ book: Book) -> some View {
        Button {
            tappedBook = book
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(book.title)
                        .font(.body.bold())
                        .foregroundStyle(.primary)

                    HStack(spacing: 4) {
                        Text(
                            book.authors.isEmpty
                            ? "Unknown author"
                            : viewModel.filteredAuthorsString(book.authors)
                        )
                        .font(.caption)
                        .foregroundStyle(.secondary)

                        Spacer()

                        HStack(spacing: 2) {
                            Image(systemName: "book.pages")
                            Text(book.displayPages)
                        }

                        HStack(spacing: 2) {
                            Image(systemName: "calendar")
                            Text(book.displayYear)
                        }
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }

                Spacer()

                Image(systemName: book.status.displaySign)
                    .frame(width: 40, height: 40)
                    .foregroundStyle(.secondary)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private var addBookButton: some View {
        Button {
            showAddBook = true
        } label: {
            Label("Add book", systemImage: "plus")
                .font(.headline)
                .padding(.horizontal, 48)
                .padding(.vertical, 15)
                .background(.ultraThinMaterial)
                .foregroundStyle(.white)
                .background(.blue)
                .clipShape(Capsule())
                .shadow(color: .black.opacity(0.12), radius: 8, y: 4)
        }
        .padding(.bottom, 12)
    }
}
