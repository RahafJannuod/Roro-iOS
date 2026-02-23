import Foundation
import Combine
/// Example usage:
/// Task {
///     await viewModel.loadAll()
/// }

@MainActor
final class ProductsViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    private let service = ProductService()

    func loadAll() async {
        isLoading = true
        errorMessage = nil

        do {
            products = try await service.fetchProducts()
        } catch let error as NetworkError {
            switch error {
            case .invalidURL:
                errorMessage = "Invalid URL"
            case .requestFailed(let statusCode):
                errorMessage = "HTTP error: \(statusCode)"
            case .decodingError(let decodingError):
                errorMessage = "Failed to decode data: \(decodingError.localizedDescription)"
            case .unknown(let underlyingError):
                errorMessage = "Network error: \(underlyingError.localizedDescription)"
            }
        } catch {
            errorMessage = "An unexpected error occurred: \(error.localizedDescription)"
        }

        isLoading = false
    }
}