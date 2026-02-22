import Foundation
import SwiftUI
import Combine

enum SortOption {
    case none
    case priceAsc
    case priceDesc
    case ratingDesc
}

@MainActor
class ProductListViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var filtered: [Product] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var searchText: String = ""
    @Published var selectedCategory: String? = nil
    @Published var sortOption: SortOption = .none

    private let service = ProductService()

    var availableCategories: [String] {
        Array(Set(products.compactMap { $0.category })).sorted()
    }

    func loadAll() async {
        isLoading = true
        errorMessage = nil

        do {
            let fetchedProducts = try await service.fetchProducts()
            products = fetchedProducts
            filtered = fetchedProducts
            applyFilters()
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func applyFilters() {
        var result = products

        // Filter by search text
        if !searchText.isEmpty {
            result = result.filter { product in
                product.title.localizedCaseInsensitiveContains(searchText) ||
                (product.description?.localizedCaseInsensitiveContains(searchText) ?? false)
            }
        }

        // Filter by category
        if let selectedCategory = selectedCategory {
            result = result.filter { product in
                product.category == selectedCategory
            }
        }

        // Apply sorting
        switch sortOption {
        case .none:
            break
        case .priceAsc:
            result.sort { $0.price < $1.price }
        case .priceDesc:
            result.sort { $0.price > $1.price }
        case .ratingDesc:
            result.sort { ($0.rating?.rate ?? 0) > ($1.rating?.rate ?? 0) }
        }

        filtered = result
    }

    func setCategory(_ category: String?) {
        selectedCategory = category
        applyFilters()
    }

    func setSearch(_ text: String) {
        searchText = text
        applyFilters()
    }

    func setSort(_ option: SortOption) {
        sortOption = option
        applyFilters()
    }
}
