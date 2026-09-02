//
//  BarcodeScannerView.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 30/08/2026.
//

import SwiftUI
import VisionKit
import Vision

struct BarcodeScannerView: View {

    let onScan: (String) -> Void

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Scan Barcode")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") { dismiss() }
                    }
                }
        }
    }

    @ViewBuilder
    private var content: some View {
        if DataScannerViewController.isSupported && DataScannerViewController.isAvailable {
            DataScannerRepresentable { isbn in
                onScan(isbn)
                dismiss()
            }
            .ignoresSafeArea(edges: .bottom)
        } else {
            unavailableView
        }
    }

    private var unavailableView: some View {
        ContentUnavailableView(
            "Scanning Unavailable",
            systemImage: "barcode.viewfinder",
            description: Text("Barcode scanning isn't supported on this device. Enter the ISBN manually instead.")
        )
    }
}

private struct DataScannerRepresentable: UIViewControllerRepresentable {

    let onScan: (String) -> Void

    func makeUIViewController(context: Context) -> DataScannerViewController {
        let controller = DataScannerViewController(
            recognizedDataTypes: [.barcode(symbologies: [.ean13, .ean8, .upce])],
            qualityLevel: .balanced,
            isHighFrameRateTrackingEnabled: false,
            isPinchToZoomEnabled: true,
            isGuidanceEnabled: true,
            isHighlightingEnabled: true
        )
        controller.delegate = context.coordinator
        try? controller.startScanning()
        return controller
    }

    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(onScan: onScan)
    }

    final class Coordinator: NSObject, DataScannerViewControllerDelegate {
        private let onScan: (String) -> Void
        private var hasScanned = false

        init(onScan: @escaping (String) -> Void) {
            self.onScan = onScan
        }

        func dataScanner(_ dataScanner: DataScannerViewController, didAdd items: [RecognizedItem], allItems: [RecognizedItem]) {
            guard !hasScanned, let item = items.first else { return }

            if case .barcode(let barcode) = item, let payload = barcode.payloadStringValue {
                hasScanned = true
                onScan(payload)
            }
        }
    }
}
