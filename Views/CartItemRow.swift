import SwiftUI

struct CartItemRow: View {
    let item: CartManager.CartItem
    @EnvironmentObject private var cart: CartManager

    var body: some View {
        HStack(spacing: 12) {
            // Thumbnail
            AsyncImage(url: item.product.image) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let img):
                    img.resizable().scaledToFill()
                case .failure:
                    Image(systemName: "photo")
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 72, height: 72)
            .background(Color(UIColor.systemGray6))
            .cornerRadius(12)
            .clipped()

            // Title + price
            VStack(alignment: .leading, spacing: 6) {
                Text(item.product.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                    .lineLimit(2)

                Text(String(format: "$%.2f", item.product.price))
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(Color.orange)
            }

            Spacer()

            // Quantity controls
            HStack(spacing: 12) {
                Button {
                    cart.decrease(id: item.id)
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .font(.title2)
                }

                Text("\(item.quantity)")
                    .font(.system(size: 16, weight: .semibold))
                    .frame(minWidth: 28)

                Button {
                    cart.increase(id: item.id)
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                }
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 8)
    }
}
