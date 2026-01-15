//
//  EditSeriesView.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 15/01/2026.
//

import Foundation
import SwiftUI

struct EditSeriesView: View {

    @State private var seriesName: String = ""

    @Environment(\.dismiss) private var dismiss

    @FocusState private var isNameFieldFocused: Bool

    var onSave: (Series) -> Void

    var body: some View {
        NavigationView {
            VStack {
                mainForm
            }
            .navigationTitle("Add Series")
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
                TextField("Enter series name", text: $seriesName)
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
                    let newSeries = Series(name: seriesName)

                    onSave(newSeries)
                    dismiss()
                }
                .disabled(seriesName.isEmpty)
            }
        }
    }
}
