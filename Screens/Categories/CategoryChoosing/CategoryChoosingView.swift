//
//  CategoryChoosingView.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 16/01/2026.
//

import SwiftUI

struct CategoryChoosingView: View {

    @State private var viewModel: CategoryChoosingViewModel

    @Binding var selectedCategory: Category

    @State private var showAddCategory: Bool = false

    init(selectedCategory: Binding<Category>) {
        _selectedCategory = selectedCategory
        _viewModel = State(initialValue: CategoryChoosingViewModel(selectedCategory: selectedCategory.wrappedValue))
    }

    var body: some View {
        VStack {
            categoriesList

            addCategoryButton
        }
        .navigationTitle("Categories")
    }

    private var categoriesList: some View {
        List {
            ForEach(viewModel.categories, id: \.id) { category in
                HStack {
                    Text(category.name)

                    Spacer()

                    if category == selectedCategory {
                        Image(systemName: "checkmark")
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    selectedCategory = category
                }

            }
        }
    }

    private var addCategoryButton: some View {
        Button {
            showAddCategory = true
        } label: {
            Label("Add category", systemImage: "plus.circle.fill")
                .font(.title2)
        }
       .padding()
       .sheet(isPresented: $showAddCategory) {
           EditCategoryView { newCategory in
               viewModel.addCategory(newCategory)
               selectedCategory = newCategory
           }
       }
    }
}
