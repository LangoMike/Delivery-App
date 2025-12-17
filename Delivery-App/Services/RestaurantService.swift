//
//  RestaurantService.swift
//  Delivery-App
//
//  Created by Mike Gweth Lango on 12/10/25.
//

import Foundation

/// Service for fetching restaurant data
class RestaurantService {
    private let apiClient: APIClient
    
    init(apiClient: APIClient = .shared) {
        self.apiClient = apiClient
    }
    
    /// Fetches list of restaurants
    /// Uses mock data if API key is not configured - replace with Spoonacular API integration when ready
    func fetchRestaurants() async throws -> [Restaurant] {
        // Check if API key is available
        let apiKey = APIConfig.getAPIKey(for: .spoonacular)
        
        if apiKey.isEmpty {
            // Return mock data for development
            return mockRestaurants()
        }
        
        // TODO: Implement Spoonacular API integration
        // Spoonacular doesn't have a direct restaurant API, so we'll use mock data
        // In production, you might use Yelp Fusion API or another restaurant API
        return mockRestaurants()
    }
    
    /// Returns mock restaurant data
    private func mockRestaurants() -> [Restaurant] {
        return [
            Restaurant(id: "1", name: "Pizza Palace", cuisine: "Italian", rating: 4.5, imageURL: nil),
            Restaurant(id: "2", name: "Burger Barn", cuisine: "American", rating: 4.2, imageURL: nil),
            Restaurant(id: "3", name: "Sushi Express", cuisine: "Japanese", rating: 4.8, imageURL: nil),
            Restaurant(id: "4", name: "Taco Fiesta", cuisine: "Mexican", rating: 4.3, imageURL: nil),
            Restaurant(id: "5", name: "Curry House", cuisine: "Indian", rating: 4.6, imageURL: nil)
        ]
    }
}

