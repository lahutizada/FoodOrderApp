import Foundation

struct Dish: Equatable, Codable {
    let name: String
    let imageName: String
    let price: Double
}

struct UserCart: Codable {
    let userEmail: String
    var items: [CartItem]
}

struct CartItem: Codable {
    let dish: Dish
    var quantity: Int
}

struct MenuCategory {
    let title: String
    let imageName: String
    let dishes: [Dish]
}
