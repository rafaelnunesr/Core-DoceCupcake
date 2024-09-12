import Vapor

struct APIOrderList: Content, Codable {
    let count: Int
    let orders: [APIOrder]
}
