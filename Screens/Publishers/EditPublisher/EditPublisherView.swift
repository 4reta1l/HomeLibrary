//
//  EditPublisherView.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 14/01/2026.
//

import Foundation
import SwiftUI

struct EditPublisherView: View {

    @State private var publisherName: String = ""

    @Environment(\.dismiss) private var dismiss

    @FocusState private var isNameFieldFocused: Bool

    var onSave: (Publisher) -> Void

    var body: some View {
        NavigationView {
            VStack {
                mainForm
            }
            .navigationTitle("Add publisher")
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
                TextField("Enter publisher name", text: $publisherName)
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
                    let newPublisher = Publisher(name: publisherName)

                    onSave(newPublisher)
                    dismiss()
                }
                .disabled(publisherName.isEmpty)
            }
        }
    }
}
