import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ProductListViewModel()
    @EnvironmentObject private var cartManager: CartManager

    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundMain
                    .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        FeaturedSectionView(products: viewModel.filtered)

                        // Header
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("Discover")
                                    .font(.system(size: 34, weight: .bold))
                                    .foregroundColor(.textDark)
                                Spacer()
                                NavigationLink("See All") {
                                    ProductListView()
                                }
                                .font(.subheadline)
                                .foregroundColor(.primary)
                            }

                            // Search Bar
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.textLight)
                                TextField("Search products...", text: $viewModel.searchText)
                                    .foregroundColor(.textDark)
                                    .onChange(of: viewModel.searchText) { newValue in
                                        viewModel.setSearch(newValue)
                                    }
                                Spacer()
                            }
                            .padding()
                            .background(Color.backgroundCard)
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)

                        // Product Filters
                        ProductFiltersView(
                            categories: viewModel.availableCategories,
                            selectedCategory: $viewModel.selectedCategory,
                            sortOption: $viewModel.sortOption
                        ) {
                            viewModel.setCategory(nil)
                            viewModel.setSort(.none)
                            viewModel.setSearch("")
                        }

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
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .font(.largeTitle)
                                    .foregroundColor(.orange)
                                Text(errorMessage)
                                    .foregroundColor(.textLight)
                                    .multilineTextAlignment(.center)
                                Button("Retry") {
                                    Task { await viewModel.loadAll() }
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
                            ForEach(viewModel.filtered) { product in
                                NavigationLink(destination: ProductDetailView(product: product)) {
                                    ProductCardView(product: product)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .toolbar(.hidden) // إن أردتِ إظهار أشياء في المستقبل ضعيها هنا
        }
        .task { await viewModel.loadAll() }
    }
}

// ProductCardView مع زر إضافة للسلة
struct ProductCardView: View {
    let product: Product
    @EnvironmentObject private var cartManager: CartManager

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topTrailing) {
                // Product Image (safe AsyncImage)
                if let url = product.image {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(height: 140)
                                .frame(maxWidth: .infinity)
                        case .success(let img):
                            img
                                .resizable()
                                .scaledToFill()
                                .frame(height: 140)
                                .frame(maxWidth: .infinity)
                                .clipped()
                        case .failure:
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 140)
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.secondary)
                        @unknown default:
                            EmptyView()
                                .frame(height: 140)
                                .frame(maxWidth: .infinity)
                        }
                    }
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 140)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.secondary)
                }

                // Add to cart small button (top-right)
                Button {
                    cartManager.add(product: product)
                } label: {
                    Image(systemName: "cart.badge.plus")
                        .padding(8)
                        .background(Color.white.opacity(0.9))
                        .clipShape(Circle())
                }
                .padding(8)
                .buttonStyle(.plain)
                .shadow(radius: 2)
            }
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)

            // Product Info
            VStack(alignment: .leading, spacing: 4) {
                Text(product.title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.textDark)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)

                HStack(spacing: 6) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 10))
                        .foregroundColor(.yellow)
                    Text(String(format: "%.1f", product.rating?.rate ?? 0))
                        .font(.system(size: 12))
                        .foregroundColor(.textLight)

                    Spacer()
                    Text("$\(product.price, specifier: "%.2f")")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.primary)
                }
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 8)
        }
        .background(Color.backgroundCard)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 4)
    }
}

// Preview: تأكدي استخدام environmentObject
#Preview {
    ContentView()
        .environmentObject(CartManager())
}
