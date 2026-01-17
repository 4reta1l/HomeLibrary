//
//  AppView.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 16/01/2026.
//

import SwiftUI

struct AppView: View {

    @State private var store = LibraryStore()

    var body: some View{
        TabView {
            Tab("Library", systemImage: "books.vertical") {
                MyLibraryView(state: .defaultView)
                    .environment(store)
            }
            Tab("Categories", systemImage: "square.grid.2x2") {
                CategoriesView()
                    .environment(store)
            }
            Tab("Overview", systemImage: "list.bullet") {
                OverviewView()
                    .environment(store)
            }
        }
    }
}
