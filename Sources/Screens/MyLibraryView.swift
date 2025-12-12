//
//  MyLibraryView.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 12/12/2025.
//

import SwiftUI

struct MyLibraryView: View {

    @State private var viewModel = MyLibraryViewModel()

    var body: some View {
        NavigationView {
            VStack(spacing: 8) {
                booksAmount

                List {
                    ForEach(viewModel.books, id: \.id) { book in
                        bookRowView(book)
                    }
                }
            }
            .navigationTitle("My Library")
        }
    }

    private var booksAmount: some View {
        if viewModel.books.count == 1 {
            Text("1 book")
        } else {
            Text("\(viewModel.books.count) books")
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
                    Text("\(book.pages)")
                        .font(.caption)
                        .foregroundColor(.gray)

                    Image(systemName: "calendar")
                    Text("\(book.year)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }

            Spacer()

            Image(systemName: book.status.displaySign)
                .frame(width: 25, height: 25)
                .padding(.trailing, 5)
        }
        .contentShape(Rectangle())
    }
}
