//
//  SeriesView.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 15/01/2026.
//

import Foundation
import SwiftUI

struct SeriesView: View {

    @State private var viewModel: SeriesViewModel

    @Binding var selectedSeries: Series?

    @State private var showAddSeries: Bool = false

    init(selectedSeries: Binding<Series?>) {
        _selectedSeries = selectedSeries
        viewModel = SeriesViewModel(selectedSeries: selectedSeries.wrappedValue)
    }

    var body: some View {
        VStack {
            seriesList

            addSeriesButton
        }
        .navigationTitle("Series")
    }

    private var seriesList: some View {
        List {
            ForEach(viewModel.series, id: \.id) { series in
                HStack {
                    Text(series.name)

                    Spacer()

                    if series == selectedSeries {
                        Image(systemName: "checkmark")
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    toggle(series)
                }
                .swipeActions {
                    Button(role: .destructive) {
                        toggle(series)
                        viewModel.removeSeries(id: series.id)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }

            }
        }
    }

    private var addSeriesButton: some View {
        Button {
            showAddSeries = true
        } label: {
            Label("Add series", systemImage: "plus.circle.fill")
                .font(.title2)
        }
       .padding()
       .sheet(isPresented: $showAddSeries) {
           EditSeriesView { newSeries in
               viewModel.series.append(newSeries)
               selectedSeries = newSeries
           }
       }
    }

    private func toggle(_ series: Series) {

        if selectedSeries != series {
            selectedSeries = series
        } else {
            selectedSeries = nil
        }
    }
}
