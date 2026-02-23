import Foundation

// MARK: - Product model (matches fakestoreapi.com)
struct Product: Identifiable, Codable {
    let id: Int
    let title: String
    let price: Double
    let description: String?
    let category: String?
    let image: URL?
    let rating: Rating?

    // Optional convenience sample for previews (يمكن إزالته لاحقًا)
    static var sample: Product {
        Product(
            id: 1,
            title: "Fjallraven Backpack",
            price: 109.95,
            description: "Your perfect pack...",
            category: "men's clothing",
            image: URL(string: "https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg"),
            rating: Rating(rate: 3.9, count: 120)
        )
    }
}

struct Rating: Codable {
    let rate: Double
    let count: Int
}
