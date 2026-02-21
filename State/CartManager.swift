import Foundation

 struct CartItem: Identifiable {
     let id: UUID
     let product: Product
     var quantity: Int

     init(id: UUID = UUID(), product: Product, quantity: Int = 1) {
         self.id = id
         self.product = product
         self.quantity = quantity
     }
 }

 @Observable
 class CartManager {
     var items: [CartItem] = []

     func add(product: Product) {
         if let index = items.firstIndex(where: { $0.product.id == product.id
 }) {
             items[index].quantity += 1
         } else {
             let newItem = CartItem(product: product, quantity: 1)
             items.append(newItem)
         }
     }

     func remove(id: UUID) {
         items.removeAll { $0.id == id }
     }

     func updateQuantity(id: UUID, quantity: Int) {
         if let index = items.firstIndex(where: { $0.id == id }) {
             if quantity > 0 {
                 items[index].quantity = quantity
             } else {
                 items.remove(at: index)
             }
         }
     }

     func totalPrice() -> Double {
         items.reduce(0) { $0 + ($1.product.price * Double($1.quantity)) }
     }
 }

