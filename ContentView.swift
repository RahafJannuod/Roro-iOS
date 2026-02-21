import SwiftUI

  struct ContentView: View {
      @StateObject private var viewModel = ProductsViewModel()
      @Environment(CartManager.self) private var cartManager
      @State private var searchText = ""

      var body: some View {
          NavigationStack {
              ZStack {
                  Color.backgroundMain
                      .ignoresSafeArea()

                  ScrollView {
                      VStack(alignment: .leading, spacing: 20) {
                          // Header
                          VStack(alignment: .leading, spacing: 16) {
                              Text("Discover")
                                  .font(.system(size: 34, weight: .bold))
                                  .foregroundColor(.textDark)

                              // Search Bar
                              HStack {
                                  Image(systemName: "magnifyingglass")
                                      .foregroundColor(.textLight)
                                  Text("Search products...")
                                      .foregroundColor(.textLight)
                                  Spacer()
                              }
                              .padding()
                              .background(Color.backgroundCard)
                              .cornerRadius(12)
                              .shadow(color: .black.opacity(0.05), radius: 8, x:
   0, y: 2)
                          }
                          .padding(.horizontal)
                          .padding(.top, 8)

                          // Loading State
                          if viewModel.isLoading {
                              HStack {
                                  Spacer()
                                  ProgressView()
                                      .scaleEffect(1.5)
                                      .padding()
                                  Spacer()
                              }
                          }

                          // Error State
                          if let errorMessage = viewModel.errorMessage {
                              VStack(spacing: 12) {
                                  Image(systemName:
  "exclamationmark.triangle.fill")
                                      .font(.largeTitle)
                                      .foregroundColor(.orange)
                                  Text(errorMessage)
                                      .foregroundColor(.textLight)
                                      .multilineTextAlignment(.center)
                                  Button("Retry") {
                                      Task {
                                          await viewModel.loadAll()
                                      }
                                  }
                                  .buttonStyle(.bordered)
                              }
                              .padding()
                          }

                          // Products Grid
                          LazyVGrid(columns: [
                              GridItem(.flexible(), spacing: 16),
                              GridItem(.flexible(), spacing: 16)
                          ], spacing: 16) {
                              ForEach(viewModel.products) { product in
                                  NavigationLink(destination:
  ProductDetailView(product: product)) {
                                      ProductCardView(product: product)
                                  }
                                  .buttonStyle(.plain)
                              }
                          }
                          .padding(.horizontal)
                      }
                  }
              }
              .navigationBarHidden(true)
          }
          .task {
              await viewModel.loadAll()
          }
      }
  }

  struct ProductCardView: View {
      let product: Product

      var body: some View {
          VStack(alignment: .leading, spacing: 8) {
              // Product Image
              AsyncImage(url: product.image) { image in
                  image
                      .resizable()
                      .scaledToFit()
              } placeholder: {
                  ProgressView()
              }
              .frame(height: 140)
              .frame(maxWidth: .infinity)
              .background(Color.gray.opacity(0.1))
              .cornerRadius(12)

              // Product Info
              VStack(alignment: .leading, spacing: 4) {
                  Text(product.title)
                      .font(.system(size: 14, weight: .medium))
                      .foregroundColor(.textDark)
                      .lineLimit(2)
                      .multilineTextAlignment(.leading)

                  HStack(spacing: 2) {
                      Image(systemName: "star.fill")
                          .font(.system(size: 10))
                          .foregroundColor(.yellow)
                      Text(String(format: "%.1f", product.rating?.rate ?? 0))
                          .font(.system(size: 12))
                          .foregroundColor(.textLight)
                  }

                  Text("$\(product.price, specifier: "%.2f")")
                      .font(.system(size: 16, weight: .bold))
                      .foregroundColor(.primary)
              }
              .padding(.horizontal, 8)
              .padding(.bottom, 8)
          }
          .background(Color.backgroundCard)
          .cornerRadius(16)
          .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 4)
      }
  }

  #Preview {
      ContentView()
          .environment(CartManager())
  }
