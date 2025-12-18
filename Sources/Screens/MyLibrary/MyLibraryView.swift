//
//  MyLibraryView.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 12/12/2025.
//

import SwiftUI

struct MyLibraryView: View {

    @State private var viewModel = MyLibraryViewModel()

    @State private var showEditBook: Bool = false

    var body: some View {
        NavigationView {
            VStack(spacing: 8) {
                booksAmount

                List {
                    ForEach(viewModel.filteredBooks, id: \.id) { book in
                        bookRowView(book)
                    }
                }
                .sheet(isPresented: $showEditBook, onDismiss: viewModel.reloadData) {
                    EditBookView(state: .addBook)
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
                    Text("\(book.pages)")
                        .font(.caption)
                        .foregroundColor(.gray)


                    Image(systemName: "calendar")
                        .padding(.trailing, -5)
                    Text(verbatim: String(Int(book.year)))
                        .font(.caption)
                        .foregroundColor(.gray)

                }
            }

            Spacer()

            Image(systemName: book.status.displaySign)
                .frame(width: 40, height: 40)
        }
        .contentShape(Rectangle())
    }

    private var addBookButton: some View {
        Button(
            action: {
                showEditBook = true
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
    }
}
