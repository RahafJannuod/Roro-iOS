//
//  APIClient.swift
//  Roro-iOS
//
//  Created by Rahaf jannuod on 22.02.26.
//

import Foundation

struct Order: Identifiable {
    let id = UUID()
    let orderNumber: String
    let date: Date
    let total: Double
    let status: String
    let items: Int
}

final class APIClient {
    static let shared = APIClient()
    private init() {}

    func fetchOrderHistory() async throws -> [Order] {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_500_000_000)

        // Return mock data
        return [
            Order(
                orderNumber: "ORD-2024-001",
                date: Calendar.current.date(byAdding: .day, value: -5, to: Date()) ?? Date(),
                total: 129.99,
                status: "Delivered",
                items: 3
            ),
            Order(
                orderNumber: "ORD-2024-002",
                date: Calendar.current.date(byAdding: .day, value: -12, to: Date()) ?? Date(),
                total: 89.50,
                status: "Delivered",
                items: 2
            ),
            Order(
                orderNumber: "ORD-2024-003",
                date: Calendar.current.date(byAdding: .day, value: -20, to: Date()) ?? Date(),
                total: 199.99,
                status: "Delivered",
                items: 4
            )
        ]
    }

    func updateProfile(name: String, email: String) async throws {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_000_000_000)

        // Simulate success (no actual network call)
        print("Profile updated: \(name), \(email)")
    }
}
