//
//  RowView.swift
//  Roro-iOS
//
//  Created by Rahaf jannuod on 22.02.26.
//

import SwiftUI

struct RowView<TrailingContent: View>: View {
    let icon: String
    let title: String
    let showChevron: Bool
    let trailingContent: TrailingContent?

    init(
        icon: String,
        title: String,
        showChevron: Bool = false,
        @ViewBuilder trailingContent: () -> TrailingContent = { EmptyView() }
    ) {
        self.icon = icon
        self.title = title
        self.showChevron = showChevron
        self.trailingContent = trailingContent()
    }

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(.accentColor)
                .frame(width: 24, height: 24)

            Text(title)
                .font(.body)
                .foregroundColor(.primary)

            Spacer()

            if let trailingContent = trailingContent as? EmptyView {
                if showChevron {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                }
            } else {
                trailingContent
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 16)
        .background(Color(.systemBackground))
        .contentShape(Rectangle())
    }
}

// Convenience initializer for rows without trailing content
extension RowView where TrailingContent == EmptyView {
    init(icon: String, title: String, showChevron: Bool = false) {
        self.init(icon: icon, title: title, showChevron: showChevron) {
            EmptyView()
        }
    }
}

#Preview {
    VStack(spacing: 0) {
        RowView(icon: "person", title: "Edit Profile", showChevron: true)
        Divider()
        RowView(icon: "moon", title: "Dark Mode") {
            Toggle("", isOn: .constant(false))
                .labelsHidden()
        }
    }
    .background(Color(.systemGroupedBackground))
}
