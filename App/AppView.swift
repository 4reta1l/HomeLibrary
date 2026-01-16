//
//  AppView.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 16/01/2026.
//

import SwiftUI

struct AppView: View {

    var body: some View{
        TabView {
            Tab("Library", systemImage: "books.vertical") {
                MyLibraryView(state: .defaultView)
            }
            Tab("Categories", systemImage: "square.grid.2x2") {
                CategoriesView()
            }
        }
    }
}
