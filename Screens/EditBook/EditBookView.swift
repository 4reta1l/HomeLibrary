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
        case bookPages
    }

    @State private var viewModel: EditBookViewModel
    @State private var state: ViewState

    @State private var showDeleteConfirmation: Bool = false
    @State private var showMoreOptions = false

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

                bottomButtonsSection
            }
            .onAppear {
                focusField = .bookTitle
            }
            .navigationTitle(state.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                toolBarView
            }
            .alert("Delete book?",
                   isPresented: $showDeleteConfirmation) {

                Button("Delete", role: .destructive) {
                    viewModel.deleteBook()
                    dismiss()
                }

                Button("Cancel", role: .cancel) {}
            }
        }
    }

    private var mainForm: some View {
        Form {
            titleSection

            authorSection

            genreSection

            pagesYearSection

            statusSection

            showMoreButton

            if showMoreOptions {
                isbnSection

                seriesSection

                publisherSection

                notesSection
            }
        }
        .scrollDismissesKeyboard(.immediately)
    }

    private var toolBarView: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            Button("Cancel") {
                dismiss()
            }
        }
    }

    private var titleSection: some View {
        Section {
            TextField("Enter book title", text: $viewModel.bookTitle)
                .focused($focusField, equals: .bookTitle)
                .submitLabel(.next)
                .onSubmit {
                    focusField = .bookPages
                }
        } header: {
            Text("Title")
                .textCase(nil)
                .font(.subheadline)
                .bold()
                .padding(.leading, -5)
        }
    }

    private var authorSection: some View {
        Section {
            NavigationLink {
                AuthorsView(selectedAuthors: $viewModel.bookAuthors)
            } label: {
                Text(viewModel.bookAuthors.isEmpty
                     ? "Add author" : viewModel.filteredAuthorsString()
                )
            }
        } header: {
            Text("Author")
                .textCase(nil)
                .font(.subheadline)
                .bold()
                .padding(.leading, -5)
        }
    }

    private var genreSection: some View {
        Section {
            NavigationLink {
                GenresView(selectedGenres: $viewModel.bookGenres)
            } label: {
                HStack {
                    Text(viewModel.bookGenres.isEmpty
                         ? "Add genre" : viewModel.bookGenres.map(\.name).joined(separator: ", ")
                    )
                }
            }
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
                    Text("—")
                        .tag("—")
                    ForEach(viewModel.yearsArray.reversed(), id: \.self) { year in
                        Text(String(year))
                            .tag(String(year))
                    }
                }
                .pickerStyle(.menu)
                .frame(width: 100)
            }
        } header: {
            HStack {
                Text("Pages")
                    .textCase(nil)
                    .font(.subheadline)
                    .bold()
                    .padding(.leading, -5)
                Spacer()
                Text("Publication year")
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
            TextField("Enter book ISBN", text: $viewModel.bookIsbn)
        } header: {
            Text("ISBN")
                .textCase(nil)
                .font(.subheadline)
                .bold()
                .padding(.leading, -5)
        }
    }

    private var publisherSection: some View {
        Section {
            NavigationLink {
                PublishersView(selectedPublisher: $viewModel.bookPublisher)
            } label: {
                Text(viewModel.bookPublisher?.name ?? "Add publisher")
            }
        } header: {
            Text("Publisher")
                .textCase(nil)
                .font(.subheadline)
                .bold()
                .padding(.leading, -5)
        }
    }

    private var seriesSection: some View {
        Section {
            NavigationLink {
                SeriesView(selectedSeries: $viewModel.bookSeries)
            } label: {
                Text(viewModel.bookSeries?.name ?? "Add series")
            }
        } header: {
            Text("Series")
                .textCase(nil)
                .font(.subheadline)
                .bold()
                .padding(.leading, -5)
        }
    }

    private var saveButton: some View {
        Button {
            switch self.state {
            case .addBook:
                viewModel.addBook()
            case .editBook:
                viewModel.updateBook()
            }
            dismiss()
        } label: {
            Text("Save book")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(viewModel.bookTitle.isEmpty ? Color.gray : Color.blue)
                .foregroundStyle(.white)
                .cornerRadius(10)
        }
        .disabled(viewModel.bookTitle.isEmpty)
    }

    private var deleteButton: some View {
        Button {
            dismissKeyboard()
            showDeleteConfirmation.toggle()
        } label: {
            Image(systemName: "trash")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
                .background(state == .addBook ? Color.gray : Color.red)
                .cornerRadius(10)
        }
        .disabled(state == .addBook)
    }

    private var bottomButtonsSection: some View {
        HStack(spacing: 8) {
            saveButton

            deleteButton

        }
        .padding(5)
        .padding(.top, -10)
    }

    private var showMoreButton: some View {
        Button {
            withAnimation {
                showMoreOptions.toggle()
            }
        } label: {
            HStack {
                Text(showMoreOptions ? "Hide additional options" : "Show more options")
                Spacer()
                Image(systemName: showMoreOptions ? "chevron.up" : "chevron.down")
            }
        }
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
