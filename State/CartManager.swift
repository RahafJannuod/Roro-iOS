import Foundation
import Combine

@MainActor
final class CartManager: ObservableObject {
    struct CartItem: Identifiable, Equatable {
        let id: UUID
        let product: Product
        var quantity: Int

        // Equatable by id (you can change if you want product equality)
        static func == (lhs: CartItem, rhs: CartItem) -> Bool {
            return lhs.id == rhs.id
        }
    }

    @Published private(set) var items: [CartItem] = []

    // MARK: - Cart operations

    func add(product: Product, quantity: Int = 1) {
        // إذا المنتج موجود نزيد الكمية، وإلا نضيف عنصر جديد
        if let idx = items.firstIndex(where: { $0.product.id == product.id }) {
            items[idx].quantity += quantity
        } else {
            let newItem = CartItem(id: UUID(), product: product, quantity: quantity)
            items.append(newItem)
        }
    }

    func remove(id: UUID) {
        items.removeAll { $0.id == id }
    }

    func increase(id: UUID) {
        guard let i = items.firstIndex(where: { $0.id == id }) else { return }
        items[i].quantity += 1
    }

    func decrease(id: UUID) {
        guard let i = items.firstIndex(where: { $0.id == id }) else { return }
        items[i].quantity = max(1, items[i].quantity - 1)
        // لو تحب: لو صار 0 تحذف العنصر
        // if items[i].quantity <= 0 { remove(id: id) }
    }

    // MARK: - Totals

    func subtotal() -> Double {
        items.reduce(0) { $0 + ($1.product.price * Double($1.quantity)) }
    }

    func tax(rate: Double = 0.10) -> Double {
        subtotal() * rate
    }

    func totalPrice(taxRate: Double = 0.10) -> Double {
        subtotal() + tax(rate: taxRate)
    }

    // اختياري: دوال مساعدة
    func countTotalItems() -> Int {
        items.reduce(0) { $0 + $1.quantity }
    }

    // يمكنك إضافة حفظ محلي (UserDefaults) لاحقاً
}
