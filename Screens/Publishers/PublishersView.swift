//
//  PublishersView.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 13/01/2026.
//

import Foundation
import SwiftUI

struct PublishersView: View {

    @State private var viewModel: PublishersViewModel

    @Binding var selectedPublisher: Publisher?

    @State private var showAddPublisher: Bool = false

    init(selectedPublisher: Binding<Publisher?>) {
        _selectedPublisher = selectedPublisher
        viewModel = PublishersViewModel(selectedPublisher: selectedPublisher.wrappedValue)
    }

    var body: some View {
        VStack {
            publishersList

            addPublisherButton
        }
        .navigationTitle("Publishers")
    }

    private var publishersList: some View {
        List {
            ForEach(viewModel.publishers, id: \.id) { publisher in
                HStack {
                    Text(publisher.name)

                    Spacer()

                    if publisher == selectedPublisher {
                        Image(systemName: "checkmark")
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    toggle(publisher)
                }
                .swipeActions {
                    Button(role: .destructive) {
                        toggle(publisher)
                        viewModel.removePublisher(id: publisher.id)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }

            }
        }
    }

    private var addPublisherButton: some View {
        Button {
            showAddPublisher = true
        } label: {
            Label("Add publisher", systemImage: "plus.circle.fill")
                .font(.title2)
        }
       .padding()
       .sheet(isPresented: $showAddPublisher) {
           EditPublisherView { newPublisher in
               viewModel.publishers.append(newPublisher)
               selectedPublisher = newPublisher
           }
       }
    }

    private func toggle(_ publisher: Publisher) {

        if selectedPublisher != publisher {
            selectedPublisher = publisher
        } else {
            selectedPublisher = nil
        }
    }
}
