import Foundation

struct Order: Identifiable, Codable {
    let id = UUID()
    let orderNumber: String
    let date: Date
    let total: Double
    let status: String
    let items: Int

    enum CodingKeys: String, CodingKey {
        case orderNumber, date, total, status, items
    }
}