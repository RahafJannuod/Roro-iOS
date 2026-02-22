import Foundation
import Combine

final class CartManager: ObservableObject {
    struct CartItem: Identifiable, Equatable {
        let id: UUID
        let productID: Int
        let title: String
        let price: Double
        var quantity: Int

        init(productID: Int, title: String, price: Double, quantity: Int = 1) {
            self.id = UUID()
            self.productID = productID
            self.title = title
            self.price = price
            self.quantity = quantity
        }

        static func == (lhs: CartItem, rhs: CartItem) -> Bool {
            lhs.id == rhs.id
        }
    }

    @Published private(set) var items: [CartItem] = []

    func add(product: Product, quantity: Int = 1) {
        // افترض أن Product.id هو Int (عدّلي لو نوعه مختلف)
        let pid = product.id
        if let idx = items.firstIndex(where: { $0.productID == pid }) {
            items[idx].quantity += quantity
        } else {
            let item = CartItem(productID: pid, title: product.title, price: product.price, quantity: quantity)
            items.append(item)
        }
    }

    func remove(id: UUID) {
        items.removeAll { $0.id == id }
    }

    func updateQuantity(id: UUID, quantity: Int) {
        guard let idx = items.firstIndex(where: { $0.id == id }) else { return }
        if quantity <= 0 {
            remove(id: id)
        } else {
            items[idx].quantity = quantity
        }
    }

    func totalPrice() -> Double {
        items.reduce(0) { $0 + (Double($1.quantity) * $1.price) }
    }

    func totalCount() -> Int {
        items.reduce(0) { $0 + $1.quantity }
    }

    func clear() { items.removeAll() }
}
