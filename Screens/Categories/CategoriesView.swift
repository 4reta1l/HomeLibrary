//
//  CategoriesView.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 16/01/2026.
//

import SwiftUI

struct CategoriesView: View {

    @Environment(LibraryStore.self) private var store

    var body: some View {
        NavigationView {
            VStack(spacing: 8) {
                List {
                    ForEach(store.categories, id: \.id) { category in
                        NavigationLink {
                            MyLibraryView(state: .forCategory(category: category))
                        } label: {
                            HStack {
                                Text(category.name)
                                Spacer()
                                Text(store.displayBooksCountForCategory(category))
                            }
                        }
                    }
                }
            }
            .navigationTitle("My categories")
        }
    }
}
