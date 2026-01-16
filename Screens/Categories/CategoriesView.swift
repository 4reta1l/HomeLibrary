//
//  CategoriesView.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 16/01/2026.
//

import SwiftUI

struct CategoriesView: View {

    @State private var viewModel = CategoriesViewModel()

    var body: some View {
        NavigationView {
            VStack(spacing: 8) {
                List {
                    ForEach(viewModel.categories, id: \.id) { category in
                        NavigationLink {
                            MyLibraryView(state: .forCategory(category: category))
                        } label: {
                            HStack {
                                Text(category.name)
                                Spacer()
                                Text(viewModel.amountForSpecificCategory(category))
                            }
                        }
                    }
                }
            }
            .navigationTitle("My categories")
        }
        .onAppear {
            viewModel.reloadData()
        }
    }
}
