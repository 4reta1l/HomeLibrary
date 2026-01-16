//
//  CategoriesView.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 16/01/2026.
//

import SwiftUI

struct CategoriesView: View {

    @Environment(LibraryStore.self) private var store

    @State private var showAddCategory: Bool = false

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

                addCategoryButton
            }
            .navigationTitle("My categories")
        }
    }

    private var addCategoryButton: some View {
        Button {
            showAddCategory = true
        } label: {
            Text("Add category")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(.green)
                .foregroundStyle(.white)
                .cornerRadius(10)
                .padding(.horizontal)
                .padding(.top, -5)
        }
       .sheet(isPresented: $showAddCategory) {
           EditCategoryView { newCategory in
               store.addCategory(newCategory)
           }
       }
    }
}
