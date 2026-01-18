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

    var body: some View {
        NavigationView {
            VStack(spacing: 8) {
                booksAmount

                List {
                    ForEach(viewModel.filteredBooks(from: store.books), id: \.id) { book in
                        bookRowView(book)
                    }
                }
                .sheet(item: $tappedBook) {
                    EditBookView(
                        state: .editBook(book: $0)
                    )
                }
                addBookButton
            }
            .navigationTitle("My Library")
            .searchable(
                text: $viewModel.searchText,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "Search for a book"
            )
            .toolbar {
                Group {
                    filtersToolBar
                    settingsToolBar
                }
            }
            .popover(isPresented: $showFilters, arrowEdge: .top) {
                FiltersView(authors: store.authors, genres: store.genres, filters: $viewModel.filters)
            }
        }
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
                Image(systemName: "gear")
            }
            .sheet(isPresented: $showSettings, onDismiss: store.reloadAll) {
                SettingsView()
            }
        }
    }

    private var booksAmount: some View {
        let count = viewModel.filteredBooks(from: store.books).count
        return Text(count == 1 ? "1 book" : "\(count) books")
    }

    private func bookRowView(_ book: Book) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(book.title)
                    .font(.body)
                    .bold()

                HStack {
                    Text(
                        book.authors.isEmpty
                        ? "Unknown author"
                        : viewModel.filteredAuthorsString(book.authors)
                    )
                            .font(.caption)
                            .foregroundColor(.gray)
                    Spacer()

                    Image(systemName: "book.pages")
                        .padding(.trailing, -5)
                    Text(book.displayPages)
                        .font(.caption)
                        .foregroundColor(.gray)

                    Image(systemName: "calendar")
                        .padding(.trailing, -5)
                    Text(book.displayYear)
                        .font(.caption)
                        .foregroundColor(.gray)

                }
            }

            Spacer()

            Image(systemName: book.status.displaySign)
                .frame(width: 40, height: 40)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            tappedBook = book
        }
        .opacity(tappedBook == book ? 0.24 : 1)
    }

    private var addBookButton: some View {
        Button(
            action: {
                showAddBook = true
            }, label: {
                Text("Add book")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.blue)
                    .foregroundStyle(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .padding(.top, -5)
            }
        )
        .sheet(isPresented: $showAddBook) {
            switch self.state {
            case .defaultView:
                EditBookView(state: .addBook(category: .default))

            case .forCategory(let category):
                EditBookView(state: .addBook(category: category))
            }
        }
    }
}
