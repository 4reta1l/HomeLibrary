//
//  EditBookView.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 17/12/2025.
//

import SwiftUI

struct EditBookView: View {

    enum ViewState: Equatable {
        case addBook(category: Category)
        case editBook(book: Book)

        var isAddBook: Bool {
            if case .addBook = self { return true }
            return false
        }

        var title: String {
            switch self {
            case .addBook: "Add Book"
            case .editBook: "Edit Book"
            }
        }
    }

    enum FocusedField {
        case bookTitle, bookPages
    }

    @State private var viewModel: EditBookViewModel
    @State private var state: ViewState
    @State private var showDeleteConfirmation = false
    @State private var showMoreOptions = false
    @FocusState private var focusField: FocusedField?

    @Environment(LibraryStore.self) private var store
    @Environment(\.dismiss) private var dismiss

    init(state: ViewState) {
        _viewModel = State(initialValue: EditBookViewModel(state: state))
        self.state = state
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                mainForm

                floatingButtons
            }
            .onAppear { focusField = .bookTitle }
            .navigationTitle(state.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { toolBarView }
            .alert("Delete Book?", isPresented: $showDeleteConfirmation) {
                Button("Delete", role: .destructive) {
                    if let book = viewModel.editedBook {
                        try? store.deleteBook(book)
                    }
                    dismiss()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This action cannot be undone.")
            }
            .alert(
                "Lookup Failed",
                isPresented: Binding(
                    get: { viewModel.lookupErrorMessage != nil },
                    set: { isPresented in
                        if !isPresented { viewModel.lookupErrorMessage = nil }
                    }
                )
            ) {
                Button("OK") {}
            } message: {
                Text(viewModel.lookupErrorMessage ?? "")
            }
            .sheet(isPresented: $viewModel.isScannerPresented) {
                BarcodeScannerView { isbn in
                    viewModel.applyScannedISBN(isbn)
                }
            }
        }
    }

    // MARK: - Form

    private var mainForm: some View {
        Form {
            titleSection
            isbnSection
            authorGenreSection
            detailsSection
            showMoreButton

            if showMoreOptions {
                additionalSection
                notesSection
            }
        }
        .listStyle(.insetGrouped)
        .scrollDismissesKeyboard(.immediately)
        .safeAreaInset(edge: .bottom) {
            Color.clear.frame(height: 70)
        }
    }

    // MARK: - Toolbar

    private var toolBarView: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            Button("Cancel") { dismiss() }
        }
    }

    // MARK: - Sections

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(.primary)
    }

    private var titleSection: some View {
        Section {
            TextField("Enter title", text: $viewModel.bookTitle)
                .font(.body)
                .focused($focusField, equals: .bookTitle)
                .submitLabel(.next)
                .onSubmit { focusField = .bookPages }
        } header: {
            sectionHeader("Title")
        }
    }

    private var isbnSection: some View {
        Section {
            HStack {
                TextField("ISBN", text: $viewModel.bookIsbn)

                if viewModel.isLookingUpBook {
                    ProgressView()
                } else {
                    Button {
                        dismissKeyboard()
                        viewModel.isScannerPresented = true
                    } label: {
                        Image(systemName: "barcode.viewfinder")
                    }
                }
            }
        } header: {
            sectionHeader("ISBN")
        }
    }

    private var authorGenreSection: some View {
        Section {
            NavigationLink {
                AuthorsView(selectedAuthors: $viewModel.bookAuthors)
            } label: {
                rowView(
                    title: "Author",
                    value: viewModel.bookAuthors.isEmpty
                    ? "Add"
                    : viewModel.filteredAuthorsString(),
                    isEmpty: viewModel.bookAuthors.isEmpty
                )
            }

            NavigationLink {
                GenresView(selectedGenres: $viewModel.bookGenres)
            } label: {
                rowView(
                    title: "Genre",
                    value: viewModel.bookGenres.isEmpty
                    ? "Add"
                    : viewModel.bookGenres.map(\.name).joined(separator: ", "),
                    isEmpty: viewModel.bookGenres.isEmpty
                )
            }
        } header: {
            sectionHeader("Details")
        }
    }

    private var detailsSection: some View {
        Section {
            HStack {
                Text("Pages:")

                Spacer()

                TextField("0", text: $viewModel.bookPages)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.trailing)
                    .frame(width: 80)
                    .focused($focusField, equals: .bookPages)
            }

            HStack {
                Text("Year:")

                Spacer()

                Picker("", selection: $viewModel.bookYear) {
                    Text("—").tag("—")
                    ForEach(viewModel.yearsArray.reversed(), id: \.self) {
                        Text(String($0)).tag(String($0))
                    }
                }
                .pickerStyle(.menu)
            }

            HStack {
                Text("Status:")

                Spacer()

                Picker("", selection: $viewModel.bookStatus) {
                    ForEach(Status.allCases, id: \.self) {
                        Text($0.rawValue.capitalized)
                    }
                }
                .pickerStyle(.menu)
            }
        } header: {
            sectionHeader("Book Info")
        }
    }

    private var additionalSection: some View {
        Section {
            NavigationLink {
                CategoryChoosingView(selectedCategory: $viewModel.bookCategory)
            } label: {
                rowView(
                    title: "Category",
                    value: viewModel.bookCategory.name
                )
            }

            NavigationLink {
                SeriesView(selectedSeries: $viewModel.bookSeries)
            } label: {
                rowView(
                    title: "Series",
                    value: viewModel.bookSeries?.name ?? "Add",
                    isEmpty: viewModel.bookSeries == nil
                )
            }

            NavigationLink {
                PublishersView(selectedPublisher: $viewModel.bookPublisher)
            } label: {
                rowView(
                    title: "Publisher",
                    value: viewModel.bookPublisher?.name ?? "Add",
                    isEmpty: viewModel.bookPublisher == nil
                )
            }
        }
    }

    private var notesSection: some View {
        Section {
            ZStack(alignment: .topLeading) {
                if viewModel.bookNotes.isEmpty {
                    Text("Write your notes here…")
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 13)
                        .padding(.vertical, 16)
                        .allowsHitTesting(false)
                }

                TextEditor(text: $viewModel.bookNotes)
                    .frame(minHeight: 120)
                    .padding(8)
                    .scrollContentBackground(.hidden)
            }
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.secondarySystemBackground))
            )
        }
    }

    private var showMoreButton: some View {
        Section {
            Button {
                withAnimation(.easeInOut(duration: 0.25)) {
                    showMoreOptions.toggle()
                }
            } label: {
                HStack {
                    Text("Additional options")
                    Spacer()
                    Image(systemName: "chevron.down")
                        .rotationEffect(.degrees(showMoreOptions ? 180 : 0))
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    // MARK: - Bottom Buttons

    private var saveButton: some View {
        Button {
            switch state {
            case .addBook: try? store.addBook(viewModel.makeBook())
            case .editBook: try? store.updateBook(viewModel.makeBook())
            }
            dismiss()
        } label: {
            Label("Save", systemImage: "checkmark")
                .font(.headline)
                .padding(.horizontal, 48)
                .padding(.vertical, 15)
                .background(.ultraThinMaterial)
                .foregroundStyle(.white)
                .background(viewModel.bookTitle.isEmpty ? .gray : .blue)
                .clipShape(Capsule())
                .shadow(color: .black.opacity(0.12), radius: 8, y: 4)
        }
        .disabled(viewModel.bookTitle.isEmpty)
    }

    private var scanButton: some View {
        circleButton(systemImage: "barcode.viewfinder", tint: .blue) {
            dismissKeyboard()
            viewModel.isScannerPresented = true
        }
    }

    private var deleteButton: some View {
        circleButton(systemImage: "trash", tint: .red) {
            dismissKeyboard()
            showDeleteConfirmation = true
        }
    }

    private func circleButton(systemImage: String, tint: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .frame(width: 50, height: 50)
        }
        .background(.ultraThinMaterial)
        .foregroundStyle(tint)
        .clipShape(Circle())
        .overlay(
            Circle()
                .stroke(tint.opacity(0.3))
        )
    }

    private var floatingButtons: some View {
        ZStack {
            saveButton
                .frame(maxWidth: .infinity, alignment: .center)

            HStack {
                scanButton

                Spacer()

                if !state.isAddBook {
                    deleteButton
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
    }

    // MARK: - Helpers

    private func rowView(title: String, value: String, isEmpty: Bool = false) -> some View {
        HStack {
            Text("\(title):")
            Spacer()
            Text(value)
                .foregroundStyle(isEmpty ? .secondary : .primary)
                .lineLimit(1)
        }
    }

    private func dismissKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil, from: nil, for: nil
        )
    }
}
