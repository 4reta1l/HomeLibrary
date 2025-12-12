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
                ForEach(viewModel.books, id: \.id) { book in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(book.title)
                                .font(.body)
                                .bold()

                            if !book.author.isEmpty {
                                Text(book.author)
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
            .navigationTitle("My Library")
        }
    }
}
