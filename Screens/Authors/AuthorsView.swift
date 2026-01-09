//
//  AuthorsView.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 05/01/2026.
//

import Foundation
import SwiftUI

struct AuthorsView: View {

    private var viewModel: AuthorsViewModel

    @Binding var selectedAuthors: [Author]

    @State private var showAddAuthor: Bool = false

    init(selectedAuthors: Binding<[Author]>) {
        _selectedAuthors = selectedAuthors
        viewModel = AuthorsViewModel(selectedAuthors: selectedAuthors.wrappedValue)
    }

    var body: some View {
        VStack {
            authorsList

            addAuthorButton
        }
        .navigationTitle("Authors")
    }

    private var authorsList: some View {
        List {
            ForEach(viewModel.authors, id: \.id) { author in
                HStack {
                    Text(author.displayName)

                    Spacer()

                    if selectedAuthors.contains(author) {
                        Image(systemName: "checkmark")
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    toggle(author)
                }
                .swipeActions {
                    Button(role: .destructive) {
                        toggle(author)
                        viewModel.removeAuthor(id: author.id)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }

            }
        }
    }

    private var addAuthorButton: some View {
        Button {
            showAddAuthor = true
        } label: {
            Label("Add author", systemImage: "plus.circle.fill")
                .font(.title2)
        }
       .padding()
       .sheet(isPresented: $showAddAuthor) {
           EditAuthorView { newAuthor in
               selectedAuthors.append(newAuthor)
               viewModel.authors.append(newAuthor)
           }
       }
    }

    private func toggle(_ author: Author) {

        if let index = selectedAuthors.firstIndex(of: author) {
            selectedAuthors.remove(at: index)
        } else {
            selectedAuthors.append(author)
        }
    }
}
