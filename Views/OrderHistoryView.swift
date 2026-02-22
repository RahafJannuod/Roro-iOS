//
//  OrderHistoryView.swift
//  Roro-iOS
//
//  Created by Rahaf jannuod on 22.02.26.
//

import SwiftUI

struct OrderHistoryView: View {
    @State private var orders: [Order] = []
    @State private var isLoading = true

    var body: some View {
        NavigationView {
            Group {
                if isLoading {
                    ProgressView("Loading orders...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if orders.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "bag")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("No orders yet")
                            .font(.title2)
                            .fontWeight(.semibold)
                        Text("Your order history will appear here")
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List(orders) { order in
                        OrderRow(order: order)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Order History")
            .navigationBarTitleDisplayMode(.inline)
        }
        .task {
            await loadOrders()
        }
    }

    private func loadOrders() async {
        do {
            orders = try await APIClient.shared.fetchOrderHistory()
        } catch {
            print("Failed to load orders: \(error)")
        }
        isLoading = false
    }
}

struct OrderRow: View {
    let order: Order

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Order #\(order.orderNumber)")
                    .font(.headline)
                Spacer()
                Text(order.status)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(statusColor.opacity(0.2))
                    .foregroundColor(statusColor)
                    .cornerRadius(8)
            }

            HStack {
                Text("\(order.items) items")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
                Text("$\(order.total, specifier: "%.2f")")
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }

            Text(order.date.formatted(date: .abbreviated, time: .omitted))
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }

    private var statusColor: Color {
        switch order.status.lowercased() {
        case "delivered":
            return .green
        case "shipped":
            return .blue
        case "processing":
            return .orange
        default:
            return .gray
        }
    }
}

#Preview {
    OrderHistoryView()
}
