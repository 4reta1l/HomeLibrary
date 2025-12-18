//
//  EditBookView.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 17/12/2025.
//

import SwiftUI

struct EditBookView: View {

    enum ViewState: Equatable {
        case addBook
        case editBook(book: Book)

        var title: String {
            switch self {
            case .addBook:
                "Add book"
            case .editBook:
                "Edit Book"
            }
        }
    }

    enum FocusedField {
        case bookTitle
        case bookAuthor
        case bookPages
        case bookNotes
        case bookIsbn
    }

    @State private var viewModel: EditBookViewModel

    @State private var state: ViewState

    @FocusState private var focusField: FocusedField?

    @Environment(\.dismiss) private var dismiss

    init(state: ViewState) {
        _viewModel = State(initialValue: EditBookViewModel(state: state))
        self.state = state
    }

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    mainSection

                    genreSection
                }

                Spacer()
                saveButton
            }
            .onAppear {
                focusField = .bookTitle
            }
            .navigationTitle(state.title)
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    @ViewBuilder
    private var mainSection: some View {
        TextField("Enter book title", text: $viewModel.bookTitle)
            .focused($focusField, equals: .bookTitle)
            .submitLabel(.next)
            .onSubmit {
                focusField = .bookAuthor
            }
        TextField("Enter book author", text: $viewModel.bookAuthor)
            .focused($focusField, equals: .bookAuthor)
    }

    private var genreSection: some View {
        Section {
            HStack {
                Text(viewModel.bookGenre.displayString)
                Spacer()
                Image(systemName: "chevron.right")
            }
            .contentShape(Rectangle())
        } header: {
            Text("Genre")
                .textCase(nil)
                .font(.subheadline)
                .bold()
                .padding(.leading, -10)
        }
    }

    private var saveButton: some View {
        Button(action: saveChanges) {
            Text("Save book")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(viewModel.bookTitle.isEmpty ? Color.gray : Color.blue)
                .foregroundStyle(.white)
                .cornerRadius(10)
                .padding(.horizontal)
                .padding(.top, -5)
        }
        .disabled(viewModel.bookTitle.isEmpty)
    }

    private func saveChanges() {
        //TODO: Save Changes
    }
}
