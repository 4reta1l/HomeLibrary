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
                mainForm

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

    private var mainForm: some View {
        Form {
            mainSection

            genreSection

            pagesYearSection

            statusSection

            notesSection

            isbnSection
        }
        .simultaneousGesture(
            TapGesture()
                .onEnded {
                    dismissKeyboard()
                }
        )
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
            .submitLabel(.next)
            .onSubmit {
                focusField = .bookPages
            }
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
                .padding(.leading, -5)
        }
    }

    private var pagesYearSection: some View {
        Section {
            HStack {
                TextField("Enter amount of pages", text: $viewModel.bookPages)
                    .keyboardType(.decimalPad)
                    .focused($focusField, equals: .bookPages)
                Spacer()
                Picker("", selection: $viewModel.bookYear) {
                    ForEach(viewModel.yearsArray.reversed(), id: \.self) { year in
                        Text(String(year))
                    }
                }
                .pickerStyle(.menu)
                .frame(width: 130)
            }
        } header: {
            HStack {
                Text("Pages")
                    .textCase(nil)
                    .font(.subheadline)
                    .bold()
                    .padding(.leading, -5)
                Spacer()
                Text("Year of publication")
                    .textCase(nil)
                    .font(.subheadline)
                    .bold()
                    .padding(.leading, -10)
            }
        }
    }

    private var statusSection: some View {
        Section {
            Picker("Book status", selection: $viewModel.bookStatus) {
                ForEach(Status.allCases, id: \.self) { status in
                    Text(status.rawValue.capitalized)
                }
            }
            .pickerStyle(.menu)
        } header: {
            Text("Status")
                .textCase(nil)
                .font(.subheadline)
                .bold()
                .padding(.leading, -5)
        }
    }

    private var notesSection: some View {
        Section {
            TextEditor(text: $viewModel.bookNotes)
                .frame(minHeight: 120)
                .padding(4)
        } header: {
            Text("Notes")
                .textCase(nil)
                .font(.subheadline)
                .bold()
                .padding(.leading, -5)
        }
    }

    private var isbnSection: some View {
        Section {
            TextField("Optional: Enter book ISBN", text: $viewModel.bookIsbn)
        } header: {
            Text("ISBN")
                .textCase(nil)
                .font(.subheadline)
                .bold()
                .padding(.leading, -5)
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

    private func dismissKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}
