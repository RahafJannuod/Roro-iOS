import Foundation

@MainActor
final class APIClient {
    static let shared = APIClient()
    private init() {}

    private var orders: [Order] = []

    func fetchOrderHistory() async throws -> [Order] {
        return orders
    }

    func createOrder(from cartItems: [CartManager.CartItem], total: Double) async throws -> Order {
        let newOrder = Order(
            orderNumber: "ORD-\(Int.random(in: 1000...9999))",
            date: Date(),
            total: total,
            status: "Processing",
            items: cartItems.count
        )

        orders.insert(newOrder, at: 0)
        return newOrder
    }

    func updateProfile(name: String, email: String) async throws {
        try await Task.sleep(nanoseconds: 500_000_000)
    }
}
