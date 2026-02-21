import SwiftUI

  struct ProductDetailView: View {
      let product: Product

      var body: some View {
          ScrollView {
              VStack(alignment: .leading, spacing: 20) {
                  // Product Image
                  AsyncImage(url: product.image) { image in
                      image
                          .resizable()
                          .scaledToFit()
                  } placeholder: {
                      ProgressView()
                  }
                  .frame(maxWidth: .infinity)
                  .frame(height: 300)
                  .background(Color.gray.opacity(0.1))

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
                      HStack(spacing: 4) {
                          ForEach(0..<5) { index in
                              Image(systemName: index < Int(product.rating?.rate ?? 0)
   ? "star.fill" : "star")
                                  .foregroundColor(.yellow)
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
                      // Add to cart action
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

  #Preview {
      NavigationStack {
          ProductDetailView(product: Product.example)
      }
  }

