//
//  APIConfig.swift
//  Delivery-App
//
//  Created by Mike Gweth Lango on 12/10/25.
//

import Foundation

/// Configuration for API keys and endpoints
struct APIConfig {
    // Spoonacular API configuration
    static let spoonacularAPIKey = "d017652631004a52995b88ab9fcee9e8" 
    static let spoonacularBaseURL = "https://api.spoonacular.com"
    
    // Mapbox API configuration
    static let mapboxAPIKey = "pk.eyJ1IjoibGFuZ29taWtlIiwiYSI6ImNtajliNng3ZjBhcnYzaG84MWI1bDY2bXEifQ.O9BZRdcZGir-lEZ3JbgBKg"
    static let mapboxBaseURL = "https://api.mapbox.com"
    
    /// Gets API key from environment or returns empty string
    static func getAPIKey(for service: APIService) -> String {
        switch service {
        case .spoonacular:
            return spoonacularAPIKey.isEmpty ? (ProcessInfo.processInfo.environment["SPOONACULAR_API_KEY"] ?? "") : spoonacularAPIKey
        case .mapbox:
            return mapboxAPIKey.isEmpty ? (ProcessInfo.processInfo.environment["MAPBOX_API_KEY"] ?? "") : mapboxAPIKey
        }
    }
}

enum APIService {
    case spoonacular
    case mapbox
}

