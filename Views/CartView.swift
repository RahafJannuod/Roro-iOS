import SwiftUI

struct CartView: View {
    @EnvironmentObject private var cart: CartManager

    var body: some View {
        NavigationStack {
            List {
                // نستخدم indices لتجنب ارتباك الـ ForEach/Binding
                ForEach(cart.items.indices, id: \.self) { idx in
                    let item = cart.items[idx]

                    HStack {
                        // استخدمي الحقول المتوفرة في CartItem
                        // في توصيف CartManager الذي اقترحناه، CartItem يملك `title` و `price`
                        Text(item.title)
                            .lineLimit(1)

                        Spacer()

                        Text("x\(item.quantity)")
                        Text(String(format: "$%.2f", item.price * Double(item.quantity)))
                    }
                    .padding(.vertical, 8)
                }
                .onDelete { indexSet in
                    // احذفي العناصر بناءً على المؤشرات
                    for index in indexSet {
                        let id = cart.items[index].id
                        cart.remove(id: id)
                    }
                }
            }
            .navigationTitle("Cart")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Clear") { cart.clear() }
                }
            }

            VStack {
                Spacer()
                HStack {
                    Text("Total:")
                    Spacer()
                    Text(String(format: "$%.2f", cart.totalPrice()))
                        .font(.headline)
                }
                .padding()
            }
        }
    }
}

// Preview
#Preview {
    // نكوّن CartManager صغير للاختبار مع عنصر وهمي
    let cm = CartManager()
    // إضافة عنصر تجريبي لو أردتِ رؤية النتيجة في Preview
    let sampleProduct = Product(
        id: 1,
        title: "Sample Product",
        price: 29.99,
        description: "Sample description",
        category: "sample",
        image: nil,
        rating: nil
    )
    cm.add(product: sampleProduct)

    return CartView()
        .environmentObject(cm)
}
