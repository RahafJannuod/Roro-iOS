import SwiftUI

struct ProductListView: View {
    @StateObject private var vm = ProductListViewModel()
    @EnvironmentObject private var cartManager: CartManager
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            Group {
                if vm.isLoading {
                    ProgressView("Loading…")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let err = vm.errorMessage {
                    VStack(spacing: 12) {
                        Text("Error: \(err)")
                            .foregroundColor(.red)
                        Button("Retry") { Task { await vm.loadAll() } }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List(vm.filtered, id: \.id) { product in
                        // نستخدم NavigationLink(destination:) لتجنّب حاجة Hashable
                        NavigationLink(destination: ProductDetailView(product: product)) {
                            HStack(spacing: 12) {
                                // صورة المنتج بأمان (URL? ممكن يكون nil)
                                if let url = product.image {
                                    AsyncImage(url: url) { phase in
                                        switch phase {
                                        case .empty:
                                            ProgressView()
                                                .frame(width: 64, height: 64)
                                        case .success(let img):
                                            img
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 64, height: 64)
                                                .cornerRadius(8)
                                                .clipped()
                                        case .failure:
                                            Image(systemName: "photo")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 64, height: 64)
                                                .foregroundColor(.secondary)
                                        @unknown default:
                                            EmptyView()
                                                .frame(width: 64, height: 64)
                                        }
                                    }
                                } else {
                                    Image(systemName: "photo")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 64, height: 64)
                                        .foregroundColor(.secondary)
                                }

                                VStack(alignment: .leading, spacing: 6) {
                                    Text(product.title)
                                        .font(.body)
                                        .lineLimit(2)

                                    Text(String(format: "$%.2f", product.price))
                                        .font(.subheadline)
                                        .foregroundColor(.accentColor)
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Products")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    // زر يفتح شاشة السلة (نستخدم destination بدل value)
                    NavigationLink(destination: CartView()) {
                        Image(systemName: "cart")
                    }
                }
            }
            .task { await vm.loadAll() }
        }
    }
}
