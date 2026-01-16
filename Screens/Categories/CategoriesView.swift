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
                        HStack {
                            Text(category.name)
                        }
                    }
                }
            }
            .navigationTitle("My categories")
        }
    }
}
