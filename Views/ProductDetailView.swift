import SwiftUI

struct ProductDetailView: View {
    let product: Product
    @EnvironmentObject private var cart: CartManager

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Product Image
                if let url = product.image {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(height: 300)
                                .frame(maxWidth: .infinity)
                        case .success(let img):
                            img
                                .resizable()
                                .scaledToFit()
                                .frame(height: 300)
                                .frame(maxWidth: .infinity)
                                .clipped()
                        case .failure:
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 300)
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.secondary)
                        @unknown default:
                            EmptyView()
                                .frame(height: 300)
                                .frame(maxWidth: .infinity)
                        }
                    }
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.secondary)
                }

                VStack(alignment: .leading, spacing: 12) {
                    // Title
                    Text(product.title)
                        .font(.title2)
                        .fontWeight(.bold)

                    // Price
                    Text("$\(product.price, specifier: "%.2f")")
                        .font(.title)
                        .foregroundColor(.green)

                    // Rating
                    HStack(spacing: 8) {
                        HStack(spacing: 4) {
                            ForEach(0..<5) { index in
                                Image(systemName: index < Int(product.rating?.rate ?? 0) ? "star.fill" : "star")
                                    .foregroundColor(.yellow)
                            }
                        }

                        Text("(\(product.rating?.count ?? 0))")
                            .foregroundColor(.secondary)
                            .font(.subheadline)
                    }

                    // Category
                    if let category = product.category {
                        Text(category.capitalized)
                            .font(.caption)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                    }

                    Divider()
                        .padding(.vertical, 8)

                    // Description
                    if let description = product.description {
                        Text("Description")
                            .font(.headline)
                        Text(description)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal)

                Spacer(minLength: 20)

                // Add to Cart Button
                Button(action: {
                    cart.add(product: product)
                }) {
                    Text("Add to Cart")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
        .navigationTitle("Product Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// Preview بدون الاعتماد على Product.sample
#Preview {
    let sampleRating = Rating(rate: 4.2, count: 99)
    let sampleProduct = Product(
        id: 1,
        title: "Fjallraven Backpack",
        price: 109.95,
        description: "Your perfect pack for everyday use and walks in the forest.",
        category: "men's clothing",
        image: URL(string: "https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg"),
        rating: sampleRating
    )

    return NavigationStack {
        ProductDetailView(product: sampleProduct)
            .environmentObject(CartManager())
    }
}
