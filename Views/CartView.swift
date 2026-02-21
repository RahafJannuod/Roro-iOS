import SwiftUI

struct CartView: View {
    @Environment(CartManager.self) private var cart

    var body: some View {
        NavigationStack {
            List {
                ForEach(cart.items, id: \.id) { item in
                    HStack {
                        Text(item.product.title)
                            .lineLimit(1)
                        Spacer()
                        Text("x\(item.quantity)")
                        Text("$\(item.product.price * Double(item.quantity), specifier: "%.2f")")
                    }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        let item = cart.items[index]
                        cart.remove(id: item.id)
                    }
                }

                HStack {
                    Spacer()
                    Text("Total: $\(cart.totalPrice(), specifier: "%.2f")")
                        .font(.headline)
                }
            }
            .navigationTitle("Cart")
        }
    }
}
