import Foundation

  enum NetworkError: Error {
      case invalidURL
      case invalidResponse
      case httpError(statusCode: Int)
      case decodingError
      case networkError(Error)
  }

  class ProductService {
      private let baseURL = "https://fakestoreapi.com"
      private let decoder: JSONDecoder = {
          let decoder = JSONDecoder()
          decoder.keyDecodingStrategy = .convertFromSnakeCase
          return decoder
      }()

      func fetchProducts() async throws -> [Product] {
          guard let url = URL(string: "\(baseURL)/products") else {
              throw NetworkError.invalidURL
          }

          do {
              let (data, response) = try await URLSession.shared.data(from: url)

              guard let httpResponse = response as? HTTPURLResponse else {
                  throw NetworkError.invalidResponse
              }

              guard (200...299).contains(httpResponse.statusCode) else {
                  throw NetworkError.httpError(statusCode:
  httpResponse.statusCode)
              }

              do {
                  let products = try decoder.decode([Product].self, from: data)
                  return products
              } catch {
                  throw NetworkError.decodingError
              }
          } catch let error as NetworkError {
              throw error
          } catch {
              throw NetworkError.networkError(error)
          }
      }

      func fetchProduct(id: Int) async throws -> Product {
          guard let url = URL(string: "\(baseURL)/products/\(id)") else {
              throw NetworkError.invalidURL
          }

          do {
              let (data, response) = try await URLSession.shared.data(from: url)

              guard let httpResponse = response as? HTTPURLResponse else {
                  throw NetworkError.invalidResponse
              }

              guard (200...299).contains(httpResponse.statusCode) else {
                  throw NetworkError.httpError(statusCode:
  httpResponse.statusCode)
              }

              do {
                  let product = try decoder.decode(Product.self, from: data)
                  return product
              } catch {
                  throw NetworkError.decodingError
              }
          } catch let error as NetworkError {
              throw error
          } catch {
              throw NetworkError.networkError(error)
          }
      }
  }
