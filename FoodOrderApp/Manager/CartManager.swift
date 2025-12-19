import Foundation
import UniformTypeIdentifiers

final class CartManager {
    static let shared = CartManager()
    
    private init() {
        loadCarts()
    }

    private var carts: [UserCart] = []

    private var currentEmail: String {
        UserDefaults.standard.string(forKey: "currentUserEmail") ?? ""
    }

    private var currentCartIndex: Int? {
        carts.firstIndex { $0.userEmail == currentEmail }
    }

    var items: [CartItem] {
        guard let index = currentCartIndex else { return [] }
        return carts[index].items
    }

    var itemsCount: Int {
        items.reduce(0) { $0 + $1.quantity }
    }

    var totalPrice: Double {
        items.reduce(0) { $0 + ($1.dish.price * Double($1.quantity)) }
    }
}
//MARK: FileManager
extension CartManager {

    private func getFilePath() -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let url = urls[0].appendingPathComponent("Carts", conformingTo: .json)
        print(url)
        return url
    }

    func loadCarts() {
        do {
            let data = try Data(contentsOf: getFilePath())
            carts = try JSONDecoder().decode([UserCart].self, from: data)
        } catch {
            print(error.localizedDescription)
        }
    }

    func saveCarts() {
        do {
            let data = try JSONEncoder().encode(carts)
            try data.write(to: getFilePath())
        } catch {
            print(error.localizedDescription)
        }
    }
}

//MARK: Functions
extension CartManager {
    
    func clearCurrentCart() {
        guard let index = currentCartIndex else { return }
        carts.remove(at: index)
        saveCarts()
        notifyUpdate()
    }

    private func notifyUpdate() {
        NotificationCenter.default.post(
            name: .cartUpdated,
            object: nil
        )
    }
    
    func add(_ dish: Dish) {
        if let cartIndex = currentCartIndex {
            if let itemIndex = carts[cartIndex].items.firstIndex(where: { $0.dish == dish }) {
                carts[cartIndex].items[itemIndex].quantity += 1
            } else {
                carts[cartIndex].items.append(
                    CartItem(dish: dish, quantity: 1)
                )
            }
        } else {
            carts.append(
                UserCart(
                    userEmail: currentEmail,
                    items: [CartItem(dish: dish, quantity: 1)]
                )
            )
        }
        
        saveCarts()
        notifyUpdate()
    }

    func updateQuantity(for dish: Dish, quantity: Int) {
        guard
            let cartIndex = currentCartIndex,
            let itemIndex = carts[cartIndex].items.firstIndex(where: { $0.dish == dish })
        else { return }

        if quantity <= 0 {
            carts[cartIndex].items.remove(at: itemIndex)
        } else {
            carts[cartIndex].items[itemIndex].quantity = quantity
        }

        saveCarts()
        notifyUpdate()
    }
}
