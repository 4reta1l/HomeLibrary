//
//  EditCategoryView.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 16/01/2026.
//

import SwiftUI

struct EditCategoryView: View {

    @State private var categoryName: String = ""

    @Environment(\.dismiss) private var dismiss

    @FocusState private var isNameFieldFocused: Bool

    var onSave: (Category) -> Void

    var body: some View {
        NavigationView {
            VStack {
                mainForm
            }
            .navigationTitle("Add category")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                toolBarView
            }
            .task {
                isNameFieldFocused = true
            }
        }
    }

    private var mainForm: some View {
        Form {
            Section {
                TextField("Enter category name", text: $categoryName)
                    .focused($isNameFieldFocused)
            } header: {
                Text("Display Name")
                    .textCase(nil)
                    .font(.subheadline)
                    .bold()
                    .padding(.leading, -5)
            }
        }
    }

    private var toolBarView: some ToolbarContent {
        Group {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }

            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    let newCategory = Category(name: categoryName)

                    onSave(newCategory)
                    dismiss()
                }
                .disabled(categoryName.isEmpty)
            }
        }
    }
}
