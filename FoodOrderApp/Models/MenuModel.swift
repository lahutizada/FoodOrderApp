import Foundation

struct MenuData {
    
    static let categories: [MenuCategory] = [
        
        MenuCategory(
            title: "Burgers",
            imageName: "burger",
            dishes: [
                Dish(name: "Classic Burger", imageName: "burger", price: 7.5),
                Dish(name: "Cheese Burger", imageName: "burger", price: 8.0),
                Dish(name: "Double Burger", imageName: "burger", price: 9.5),
                Dish(name: "Chicken Burger", imageName: "burger", price: 7.0),
                Dish(name: "BBQ Burger", imageName: "burger", price: 8.5),
                Dish(name: "Spicy Burger", imageName: "burger", price: 8.0),
                Dish(name: "Mushroom Burger", imageName: "burger", price: 8.8),
                Dish(name: "Bacon Burger", imageName: "burger", price: 9.0),
                Dish(name: "Veggie Burger", imageName: "burger", price: 7.2),
                Dish(name: "Mini Burger", imageName: "burger", price: 6.0)
            ]
        ),
        
        MenuCategory(
            title: "Pizza",
            imageName: "pizza",
            dishes: [
                Dish(name: "Margherita", imageName: "pizza", price: 9.0),
                Dish(name: "Pepperoni", imageName: "pizza", price: 10.5),
                Dish(name: "Four Cheese", imageName: "pizza", price: 11.0),
                Dish(name: "Hawaiian", imageName: "pizza", price: 10.0),
                Dish(name: "BBQ Chicken", imageName: "pizza", price: 11.5),
                Dish(name: "Vegetarian", imageName: "pizza", price: 9.5),
                Dish(name: "Meat Lovers", imageName: "pizza", price: 12.0),
                Dish(name: "Seafood", imageName: "pizza", price: 12.5),
                Dish(name: "Spicy Salami", imageName: "pizza", price: 10.8),
                Dish(name: "Calzone", imageName: "pizza", price: 10.0)
            ]
        ),
        
        MenuCategory(
            title: "Doners",
            imageName: "doner",
            dishes: [
                Dish(name: "Chicken Doner", imageName: "doner", price: 6.5),
                Dish(name: "Beef Doner", imageName: "doner", price: 7.0),
                Dish(name: "Mixed Doner", imageName: "doner", price: 7.5),
                Dish(name: "Doner Wrap", imageName: "doner", price: 6.8),
                Dish(name: "Cheese Doner", imageName: "doner", price: 7.2),
                Dish(name: "Spicy Doner", imageName: "doner", price: 7.0),
                Dish(name: "Big Doner", imageName: "doner", price: 8.0),
                Dish(name: "Doner Plate", imageName: "doner", price: 8.5),
                Dish(name: "Lavash Doner", imageName: "doner", price: 6.7),
                Dish(name: "Mini Doner", imageName: "doner", price: 5.5)
            ]
        ),
        
        MenuCategory(
            title: "Salads",
            imageName: "salad",
            dishes: [
                Dish(name: "Caesar Salad", imageName: "salad", price: 6.0),
                Dish(name: "Greek Salad", imageName: "salad", price: 5.5),
                Dish(name: "Chicken Salad", imageName: "salad", price: 6.5),
                Dish(name: "Tuna Salad", imageName: "salad", price: 7.0),
                Dish(name: "Fresh Salad", imageName: "salad", price: 4.5),
                Dish(name: "Avocado Salad", imageName: "salad", price: 7.5),
                Dish(name: "Quinoa Salad", imageName: "salad", price: 8.0),
                Dish(name: "Pasta Salad", imageName: "salad", price: 6.8),
                Dish(name: "Beetroot Salad", imageName: "salad", price: 5.0),
                Dish(name: "Fruit Salad", imageName: "salad", price: 4.8)
            ]
        ),
        
        MenuCategory(
            title: "Desserts",
            imageName: "dessert",
            dishes: [
                Dish(name: "Cheesecake", imageName: "dessert", price: 4.5),
                Dish(name: "Chocolate Cake", imageName: "dessert", price: 4.0),
                Dish(name: "Tiramisu", imageName: "dessert", price: 4.8),
                Dish(name: "Brownie", imageName: "dessert", price: 3.8),
                Dish(name: "Ice Cream", imageName: "dessert", price: 3.5),
                Dish(name: "Apple Pie", imageName: "dessert", price: 4.2),
                Dish(name: "Pancakes", imageName: "dessert", price: 4.0),
                Dish(name: "Waffles", imageName: "dessert", price: 4.3),
                Dish(name: "Baklava", imageName: "dessert", price: 5.0),
                Dish(name: "Muffin", imageName: "dessert", price: 3.0)
            ]
        ),
        
        MenuCategory(
            title: "Asian",
            imageName: "asian",
            dishes: [
                Dish(name: "Chicken Noodles", imageName: "asian", price: 7.5),
                Dish(name: "Beef Noodles", imageName: "asian", price: 8.0),
                Dish(name: "Fried Rice", imageName: "asian", price: 6.5),
                Dish(name: "Chicken Teriyaki", imageName: "asian", price: 9.0),
                Dish(name: "Sweet & Sour Chicken", imageName: "asian", price: 8.8),
                Dish(name: "Spring Rolls", imageName: "asian", price: 4.5),
                Dish(name: "Pad Thai", imageName: "asian", price: 9.5),
                Dish(name: "Ramen", imageName: "asian", price: 10.0),
                Dish(name: "Sushi Roll", imageName: "asian", price: 11.0),
                Dish(name: "Miso Soup", imageName: "asian", price: 4.0)
            ]
        )
    ]
}
