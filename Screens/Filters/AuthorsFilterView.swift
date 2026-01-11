//
//  AuthorsFilterView.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 11/01/2026.
//

import Foundation
import SwiftUI

struct AuthorsFilterView: View {

    var authors: [Author]

    @Binding var filters: BookFilters

    var body: some View {
        Form {
            Section(header: Text("Authors")) {
                ForEach(sortedAuthors, id: \.displayName) { author in
                    Button {
                        filters.selectedAuthors.toggle(author)
                    } label: {
                        HStack {
                            Text(author.displayName)
                            Spacer()
                            if filters.selectedAuthors.contains(author) {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            }
        }
    }

    var sortedAuthors: [Author] {
        authors
            .sorted {
                $0.displayName.localizedCaseInsensitiveCompare($1.displayName) == .orderedAscending
            }
    }
}
