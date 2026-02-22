import SwiftUI

struct CartView: View {
    @EnvironmentObject private var cart: CartManager

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                List {
                    // نستخدم indices لكي نتمكن من onDelete بسهولة
                    ForEach(0..<cart.items.count, id: \.self) { idx in
                        let item = cart.items[idx]
                        CartItemRow(item: item)
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            let id = cart.items[index].id
                            cart.remove(id: id)
                        }
                    }
                }
                .listStyle(.plain)

                // Footer: subtotal / tax / total & checkout button
                VStack(spacing: 12) {
                    HStack {
                        Text("Subtotal")
                        Spacer()
                        Text(String(format: "$%.2f", cart.subtotal()))
                    }
                    HStack {
                        Text("Tax (10%)")
                        Spacer()
                        Text(String(format: "$%.2f", cart.tax()))
                    }
                    Divider()
                    HStack {
                        Text("Total")
                            .font(.headline)
                        Spacer()
                        Text(String(format: "$%.2f", cart.totalPrice()))
                            .font(.title3)
                            .fontWeight(.bold)
                    }

                    Button {
                        // action: checkout
                    } label: {
                        Text("Proceed to Checkout")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(12)
                    }
                    .padding(.top, 8)
                }
                .padding()
                .background(Color(UIColor.systemBackground))
            }
            .navigationTitle("My Cart")
        }
    }
}
