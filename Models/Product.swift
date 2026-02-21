import Foundation

/// Represents the product rating returned from the API
struct Rating: Codable {
  
    let rate: Double
    
    /// The total number of ratings (e.g., 120)
    let count: Int
}

struct Product: Identifiable, Codable {
    
    /// Product ID
    let id: Int
    
    /// Product title
    let title: String
    
    /// Product price
    let price: Double
    
    /// Product description
    let description: String?
    
    /// Product category
    let category: String?
    
    /// Product image URL
    let image: URL?
    
    /// Product rating
    let rating: Rating?
    
    /// Example product for previews and testing
    static let example = Product(
        id: 1,
        title: "Fjallraven Backpack",
        price: 109.95,
        description: "Your perfect pack for everyday use and walks in the forest. Stash your laptop (up to 15 inches) in the padded sleeve, your everyday companion.",
        category: "men's clothing",
        image: URL(string: "https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg"),
        rating: Rating(rate: 3.9, count: 120)
    )
}
