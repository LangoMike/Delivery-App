//
//  MenuService.swift
//  Delivery-App
//
//  Created by Mike Gweth Lango on 12/10/25.
//

import Foundation

/// Service for fetching menu items for a restaurant
class MenuService {
    private let apiClient: APIClient
    
    init(apiClient: APIClient = .shared) {
        self.apiClient = apiClient
    }
    
    /// Fetches menu items for a specific restaurant
    /// Uses Spoonacular API if configured, otherwise returns mock data
    func fetchMenuItems(for restaurantId: String) async throws -> [MenuItem] {
        let apiKey = APIConfig.getAPIKey(for: .spoonacular)
        
        if apiKey.isEmpty {
            // Return mock data for development
            return mockMenuItems(for: restaurantId)
        }
        
        // TODO: Implement Spoonacular API integration
        // Use Spoonacular's recipe search to get menu items
        // For now, return mock data
        return mockMenuItems(for: restaurantId)
    }
    
    /// Returns mock menu items for a restaurant
    private func mockMenuItems(for restaurantId: String) -> [MenuItem] {
        // Mock menu data - at least 10-12 items as required
        let mockMenus: [String: [MenuItem]] = [
            "1": [ // Pizza Palace
                MenuItem(id: "1-1", restaurantId: "1", name: "Margherita Pizza", description: "Fresh mozzarella, tomato sauce, basil", priceCents: 1299, imageURL: nil),
                MenuItem(id: "1-2", restaurantId: "1", name: "Pepperoni Pizza", description: "Pepperoni, mozzarella, tomato sauce", priceCents: 1499, imageURL: nil),
                MenuItem(id: "1-3", restaurantId: "1", name: "Hawaiian Pizza", description: "Ham, pineapple, mozzarella", priceCents: 1599, imageURL: nil),
                MenuItem(id: "1-4", restaurantId: "1", name: "Meat Lovers Pizza", description: "Pepperoni, sausage, bacon, ham", priceCents: 1799, imageURL: nil),
                MenuItem(id: "1-5", restaurantId: "1", name: "Veggie Supreme", description: "Bell peppers, mushrooms, onions, olives", priceCents: 1399, imageURL: nil),
                MenuItem(id: "1-6", restaurantId: "1", name: "Garlic Bread", description: "Fresh baked with garlic butter", priceCents: 599, imageURL: nil),
                MenuItem(id: "1-7", restaurantId: "1", name: "Caesar Salad", description: "Romaine lettuce, parmesan, croutons", priceCents: 899, imageURL: nil),
                MenuItem(id: "1-8", restaurantId: "1", name: "Chicken Wings", description: "Buffalo style, 8 pieces", priceCents: 1099, imageURL: nil),
                MenuItem(id: "1-9", restaurantId: "1", name: "Chocolate Lava Cake", description: "Warm chocolate cake with vanilla ice cream", priceCents: 699, imageURL: nil),
                MenuItem(id: "1-10", restaurantId: "1", name: "Tiramisu", description: "Classic Italian dessert", priceCents: 799, imageURL: nil),
                MenuItem(id: "1-11", restaurantId: "1", name: "Coca Cola", description: "12 oz can", priceCents: 199, imageURL: nil),
                MenuItem(id: "1-12", restaurantId: "1", name: "Sprite", description: "12 oz can", priceCents: 199, imageURL: nil)
            ],
            "2": [ // Burger Barn
                MenuItem(id: "2-1", restaurantId: "2", name: "Classic Burger", description: "Beef patty, lettuce, tomato, onion", priceCents: 899, imageURL: nil),
                MenuItem(id: "2-2", restaurantId: "2", name: "Cheeseburger", description: "Beef patty, cheese, lettuce, tomato", priceCents: 999, imageURL: nil),
                MenuItem(id: "2-3", restaurantId: "2", name: "Bacon Burger", description: "Beef patty, bacon, cheese, special sauce", priceCents: 1199, imageURL: nil),
                MenuItem(id: "2-4", restaurantId: "2", name: "Chicken Burger", description: "Grilled chicken, lettuce, mayo", priceCents: 1099, imageURL: nil),
                MenuItem(id: "2-5", restaurantId: "2", name: "Veggie Burger", description: "Plant-based patty, avocado, sprouts", priceCents: 999, imageURL: nil),
                MenuItem(id: "2-6", restaurantId: "2", name: "French Fries", description: "Crispy golden fries", priceCents: 399, imageURL: nil),
                MenuItem(id: "2-7", restaurantId: "2", name: "Onion Rings", description: "Beer-battered onion rings", priceCents: 499, imageURL: nil),
                MenuItem(id: "2-8", restaurantId: "2", name: "Chicken Nuggets", description: "6 pieces with dipping sauce", priceCents: 599, imageURL: nil),
                MenuItem(id: "2-9", restaurantId: "2", name: "Milkshake", description: "Vanilla, chocolate, or strawberry", priceCents: 499, imageURL: nil),
                MenuItem(id: "2-10", restaurantId: "2", name: "Apple Pie", description: "Warm apple pie with ice cream", priceCents: 599, imageURL: nil),
                MenuItem(id: "2-11", restaurantId: "2", name: "Soft Drink", description: "Pepsi, 7UP, or Dr Pepper", priceCents: 299, imageURL: nil),
                MenuItem(id: "2-12", restaurantId: "2", name: "Iced Tea", description: "Sweet or unsweetened", priceCents: 249, imageURL: nil)
            ],
            "3": [ // Sushi Express
                MenuItem(id: "3-1", restaurantId: "3", name: "California Roll", description: "Crab, avocado, cucumber", priceCents: 699, imageURL: nil),
                MenuItem(id: "3-2", restaurantId: "3", name: "Spicy Tuna Roll", description: "Tuna, spicy mayo, cucumber", priceCents: 899, imageURL: nil),
                MenuItem(id: "3-3", restaurantId: "3", name: "Salmon Roll", description: "Fresh salmon, avocado", priceCents: 999, imageURL: nil),
                MenuItem(id: "3-4", restaurantId: "3", name: "Dragon Roll", description: "Eel, cucumber, avocado, eel sauce", priceCents: 1299, imageURL: nil),
                MenuItem(id: "3-5", restaurantId: "3", name: "Rainbow Roll", description: "Assorted fish, avocado, cucumber", priceCents: 1399, imageURL: nil),
                MenuItem(id: "3-6", restaurantId: "3", name: "Miso Soup", description: "Traditional Japanese soup", priceCents: 399, imageURL: nil),
                MenuItem(id: "3-7", restaurantId: "3", name: "Edamame", description: "Steamed soybeans", priceCents: 499, imageURL: nil),
                MenuItem(id: "3-8", restaurantId: "3", name: "Gyoza", description: "Pan-fried dumplings, 6 pieces", priceCents: 699, imageURL: nil),
                MenuItem(id: "3-9", restaurantId: "3", name: "Tempura Shrimp", description: "Battered and fried shrimp", priceCents: 1099, imageURL: nil),
                MenuItem(id: "3-10", restaurantId: "3", name: "Green Tea Ice Cream", description: "Traditional Japanese dessert", priceCents: 599, imageURL: nil),
                MenuItem(id: "3-11", restaurantId: "3", name: "Sake", description: "Japanese rice wine", priceCents: 899, imageURL: nil),
                MenuItem(id: "3-12", restaurantId: "3", name: "Green Tea", description: "Hot or iced", priceCents: 299, imageURL: nil)
            ],
            "4": [ // Taco Fiesta
                MenuItem(id: "4-1", restaurantId: "4", name: "Beef Taco", description: "Seasoned ground beef, lettuce, cheese", priceCents: 399, imageURL: nil),
                MenuItem(id: "4-2", restaurantId: "4", name: "Chicken Taco", description: "Grilled chicken, salsa, cheese", priceCents: 399, imageURL: nil),
                MenuItem(id: "4-3", restaurantId: "4", name: "Carnitas Taco", description: "Slow-cooked pork, onions, cilantro", priceCents: 449, imageURL: nil),
                MenuItem(id: "4-4", restaurantId: "4", name: "Fish Taco", description: "Battered fish, cabbage, lime crema", priceCents: 499, imageURL: nil),
                MenuItem(id: "4-5", restaurantId: "4", name: "Veggie Taco", description: "Black beans, corn, peppers, avocado", priceCents: 349, imageURL: nil),
                MenuItem(id: "4-6", restaurantId: "4", name: "Nachos", description: "Tortilla chips, cheese, jalapeños", priceCents: 799, imageURL: nil),
                MenuItem(id: "4-7", restaurantId: "4", name: "Quesadilla", description: "Cheese, chicken or beef", priceCents: 899, imageURL: nil),
                MenuItem(id: "4-8", restaurantId: "4", name: "Guacamole", description: "Fresh avocado dip with chips", priceCents: 599, imageURL: nil),
                MenuItem(id: "4-9", restaurantId: "4", name: "Churros", description: "Fried dough with cinnamon sugar", priceCents: 499, imageURL: nil),
                MenuItem(id: "4-10", restaurantId: "4", name: "Flan", description: "Caramel custard dessert", priceCents: 599, imageURL: nil),
                MenuItem(id: "4-11", restaurantId: "4", name: "Horchata", description: "Rice milk drink", priceCents: 399, imageURL: nil),
                MenuItem(id: "4-12", restaurantId: "4", name: "Jarritos", description: "Mexican soda", priceCents: 299, imageURL: nil)
            ],
            "5": [ // Curry House
                MenuItem(id: "5-1", restaurantId: "5", name: "Chicken Tikka Masala", description: "Creamy tomato curry", priceCents: 1499, imageURL: nil),
                MenuItem(id: "5-2", restaurantId: "5", name: "Butter Chicken", description: "Mild curry with butter and cream", priceCents: 1499, imageURL: nil),
                MenuItem(id: "5-3", restaurantId: "5", name: "Lamb Vindaloo", description: "Spicy curry with potatoes", priceCents: 1699, imageURL: nil),
                MenuItem(id: "5-4", restaurantId: "5", name: "Vegetable Korma", description: "Mild curry with mixed vegetables", priceCents: 1299, imageURL: nil),
                MenuItem(id: "5-5", restaurantId: "5", name: "Palak Paneer", description: "Spinach curry with cheese", priceCents: 1399, imageURL: nil),
                MenuItem(id: "5-6", restaurantId: "5", name: "Basmati Rice", description: "Steamed long-grain rice", priceCents: 399, imageURL: nil),
                MenuItem(id: "5-7", restaurantId: "5", name: "Garlic Naan", description: "Fresh baked bread with garlic", priceCents: 399, imageURL: nil),
                MenuItem(id: "5-8", restaurantId: "5", name: "Samosas", description: "Fried pastries with spiced filling, 2 pieces", priceCents: 499, imageURL: nil),
                MenuItem(id: "5-9", restaurantId: "5", name: "Mango Lassi", description: "Yogurt drink with mango", priceCents: 499, imageURL: nil),
                MenuItem(id: "5-10", restaurantId: "5", name: "Gulab Jamun", description: "Sweet milk dumplings in syrup", priceCents: 599, imageURL: nil),
                MenuItem(id: "5-11", restaurantId: "5", name: "Chai Tea", description: "Spiced Indian tea", priceCents: 299, imageURL: nil),
                MenuItem(id: "5-12", restaurantId: "5", name: "Raita", description: "Yogurt side dish", priceCents: 299, imageURL: nil)
            ]
        ]
        
        return mockMenus[restaurantId] ?? []
    }
}

