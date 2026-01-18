//
//  SeriesViewModel.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 15/01/2026.
//

import Foundation

@Observable
final class SeriesViewModel {

    private var seriesStorage: SeriesStorage
    var series: [Series]
    var selectedSeries: Series?

    init(seriesStorage: SeriesStorage = CDStorage.shared, selectedSeries: Series?) {
        self.seriesStorage = seriesStorage
        self.selectedSeries = selectedSeries
        self.series = seriesStorage.getSeries()

        mergeSelectedSeries()

        self.series
            .sort {
                $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
            }
    }

    func removeSeries(id: UUID) {
        do {
            try self.seriesStorage.deleteSeries(id)
        } catch {
            print("Failed to delete series: \(error)")
        }

        reloadSeries()
    }

    func reloadSeries() {
        self.series = seriesStorage
            .getSeries()
            .sorted {
                $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
            }
    }

    func mergeSelectedSeries() {
        guard let selectedSeries else {
            return
        }

        if !series.contains(selectedSeries) {
            series.append(selectedSeries)
        }
    }
}
