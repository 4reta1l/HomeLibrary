//
//  MyLibraryView.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 12/12/2025.
//

import SwiftUI

struct MyLibraryView: View {

    @State private var viewModel = MyLibraryViewModel()

    @State private var showAddBook: Bool = false
    @State private var tappedBook: Book?

    var body: some View {
        NavigationView {
            VStack(spacing: 8) {
                booksAmount

                List {
                    ForEach(viewModel.filteredBooks, id: \.id) { book in
                        bookRowView(book)
                    }
                }
                .sheet(item: $tappedBook, onDismiss: viewModel.reloadData) {
                    EditBookView(
                        state: .editBook(book: $0)
                    )
                }
                addBookButton
            }
            .navigationTitle("My Library")
            .searchable(text: $viewModel.searchText, prompt: "Search for a book")
        }
    }

    private var booksAmount: some View {
        if viewModel.filteredBooks.count == 1 {
            Text("1 book")
        } else {
            Text("\(viewModel.filteredBooks.count) books")
        }
    }

    private func bookRowView(_ book: Book) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(book.title)
                    .font(.body)
                    .bold()

                HStack {
                    if !book.author.isEmpty {
                        Text(book.author)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }

                    Spacer()

                    Image(systemName: "book.pages")
                        .padding(.trailing, -5)
                    Text(book.pages > 0 ? String(book.pages) : "-")
                        .font(.caption)
                        .foregroundColor(.gray)

                    Image(systemName: "calendar")
                        .padding(.trailing, -5)
                    Text(String(book.year))
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
        .sheet(isPresented: $showAddBook, onDismiss: viewModel.reloadData) {
            EditBookView(state: .addBook)
        }
    }
}
