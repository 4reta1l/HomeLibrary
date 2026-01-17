//
//  ReadingStatusProgress.swift
//  HomeLibrary
//
//  Created by Maksym Pyvovarov on 17/01/2026.
//

import SwiftUI

struct ReadingStatusProgress: View {

    let status: Status
    let count: Int
    let total: Int

    var body: some View {
        HStack {
            Label(status.rawValue.capitalized, systemImage: status.displaySign)
                .font(.subheadline)
                .frame(width: 100, alignment: .leading)

            ProgressView(value: Double(count), total: Double(max(total, 1)))
                .accentColor(statusColor)
                .frame(height: 10)

            Text("\(count)")
                .font(.subheadline)
                .frame(width: 30, alignment: .trailing)
        }
    }

    private var statusColor: Color {
        switch status {
        case .unread: return .gray
        case .reading: return .blue
        case .completed: return .green
        }
    }
}
