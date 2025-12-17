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
    /// Uses mock data with images from Spoonacular API if configured
    func fetchRestaurants() async throws -> [Restaurant] {
        let apiKey = APIConfig.getAPIKey(for: .spoonacular)
        
        var restaurants = mockRestaurants()
        
        // If API key is available, fetch images for restaurants based on cuisine
        if !apiKey.isEmpty {
            restaurants = try await enrichRestaurantsWithImages(restaurants: restaurants, apiKey: apiKey)
        }
        
        return restaurants
    }
    
    /// Enriches restaurants with images from Spoonacular API based on cuisine
    private func enrichRestaurantsWithImages(restaurants: [Restaurant], apiKey: String) async throws -> [Restaurant] {
        var enrichedRestaurants: [Restaurant] = []
        
        for restaurant in restaurants {
            // Search for food images based on cuisine type
            if let imageURL = try? await searchCuisineImage(query: restaurant.cuisine, apiKey: apiKey) {
                // Create new Restaurant with updated imageURL
                let enrichedRestaurant = Restaurant(
                    id: restaurant.id,
                    name: restaurant.name,
                    cuisine: restaurant.cuisine,
                    rating: restaurant.rating,
                    imageURL: imageURL
                )
                enrichedRestaurants.append(enrichedRestaurant)
            } else {
                // Keep original restaurant if image fetch fails
                enrichedRestaurants.append(restaurant)
            }
        }
        
        return enrichedRestaurants
    }
    
    /// Searches for cuisine-related images using Spoonacular API
    private func searchCuisineImage(query: String, apiKey: String) async throws -> String? {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "\(APIConfig.spoonacularBaseURL)/recipes/complexSearch?cuisine=\(encodedQuery)&apiKey=\(apiKey)&number=1&addRecipeInformation=false"
        
        guard let url = URL(string: urlString) else {
            return nil
        }
        
        struct RecipeSearchResponse: Codable {
            let results: [RecipeResult]
        }
        
        struct RecipeResult: Codable {
            let image: String?
        }
        
        do {
            let response: RecipeSearchResponse = try await APIClient.shared.get(url: url)
            return response.results.first?.image
        } catch {
            // If API call fails, return nil to use placeholder
            return nil
        }
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

