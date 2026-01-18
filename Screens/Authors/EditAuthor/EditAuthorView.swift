//
//  EditAuthorView.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 06/01/2026.
//

import Foundation
import SwiftUI

struct EditAuthorView: View {

    @State private var authorDisplayName: String = ""

    @Environment(\.dismiss) private var dismiss

    @FocusState private var isNameFieldFocused: Bool

    var onSave: (Author) -> Void

    var body: some View {
        NavigationView {
            VStack {
                mainForm
            }
            .navigationTitle("Add author")
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
                TextField("Enter author display name", text: $authorDisplayName)
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
                    let newAuthor = Author(displayName: authorDisplayName)

                    onSave(newAuthor)
                    dismiss()
                }
                .disabled(authorDisplayName.isEmpty)
            }
        }
    }
}
