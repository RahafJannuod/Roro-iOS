import Foundation

enum NetworkError: Error {
    case invalidURL
    case requestFailed(statusCode: Int)
    case decodingError(Error)
    case unknown(Error)
}

@MainActor
final class ProductService {
    private let baseURL = "https://fakestoreapi.com"
    private let decoder: JSONDecoder

    init() {
        decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .useDefaultKeys
        decoder.dateDecodingStrategy = .iso8601
    }

    // GET /products
    func fetchProducts() async throws -> [Product] {
        guard let url = URL(string: "\(baseURL)/products") else {
            throw NetworkError.invalidURL
        }
        return try await fetch(url: url)
    }

    // GET /products/{id}
    func fetchProduct(id: Int) async throws -> Product {
        guard let url = URL(string: "\(baseURL)/products/\(id)") else {
            throw NetworkError.invalidURL
        }
        return try await fetch(url: url)
    }

    // GET /products/categories
    func fetchCategories() async throws -> [String] {
        guard let url = URL(string: "\(baseURL)/products/categories") else {
            throw NetworkError.invalidURL
        }
        return try await fetch(url: url)
    }

    // GET /products/category/{categoryName}
    func fetchProductsByCategory(_ category: String) async throws -> [Product] {
        // Encode category for URL (spaces, slashes)
        guard let encoded = category.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed),
              let url = URL(string: "\(baseURL)/products/category/\(encoded)") else {
            throw NetworkError.invalidURL
        }
        return try await fetch(url: url)
    }

    // Generic fetch helper
    private func fetch<T: Decodable>(url: URL) async throws -> T {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 20

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
                throw NetworkError.requestFailed(statusCode: http.statusCode)
            }

            do {
                let decoded = try decoder.decode(T.self, from: data)
                return decoded
            } catch {
                throw NetworkError.decodingError(error)
            }
        } catch {
            throw NetworkError.unknown(error)
        }
    }
}
