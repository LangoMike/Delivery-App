//
//  MapboxService.swift
//  Delivery-App
//
//  Created by Mike Gweth Lango on 12/10/25.
//

import Foundation

/// Response models for Mapbox API
struct MapboxGeocodingResponse: Codable {
    let features: [MapboxFeature]
}

struct MapboxFeature: Codable {
    let geometry: MapboxGeometry
    let properties: MapboxProperties
}

struct MapboxGeometry: Codable {
    let coordinates: [Double] // [longitude, latitude]
}

struct MapboxProperties: Codable {
    let accuracy: String?
}

struct MapboxDirectionsResponse: Codable {
    let routes: [MapboxRoute]
}

struct MapboxRoute: Codable {
    let duration: Double // in seconds
}

/// Service for geocoding addresses and calculating ETAs using Mapbox API
class MapboxService {
    private let apiClient: APIClient
    private let apiKey: String
    private let mockRestaurantAddress = "285 Ag-Quad Ln, Blacksburg, VA, 24060"
    
    init(apiClient: APIClient = .shared, apiKey: String = "") {
        self.apiClient = apiClient
        self.apiKey = apiKey
    }
    
    /// Validates address using Mapbox geocoding and calculates ETA using directions API
    /// Uses mock restaurant address for all restaurants: 285 Ag-Quad Ln, Blacksburg, VA, 24060
    func calculateETA(for address: DeliveryAddress) async throws -> Int {
        // Validate address format
        guard address.isValid else {
            throw AppError.invalidAddress
        }
        
        let apiKey = APIConfig.getAPIKey(for: .mapbox)
        
        if apiKey.isEmpty {
            // Return mock ETA for development
            try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
            return Int.random(in: 20...40)
        }
        
        // Geocode the delivery address to validate it
        let deliveryCoordinates = try await geocodeAddress(address)
        
        // Geocode the mock restaurant address
        let restaurantAddress = DeliveryAddress(
            line1: "285 Ag-Quad Ln",
            city: "Blacksburg",
            state: "VA",
            zip: "24060"
        )
        let restaurantCoordinates = try await geocodeAddress(restaurantAddress)
        
        // Calculate ETA using directions API
        let etaMinutes = try await calculateDirectionsETA(
            from: restaurantCoordinates,
            to: deliveryCoordinates
        )
        
        return etaMinutes
    }
    
    /// Geocodes an address using Mapbox Geocoding API
    private func geocodeAddress(_ address: DeliveryAddress) async throws -> (Double, Double) {
        let apiKey = APIConfig.getAPIKey(for: .mapbox)
        let query = "\(address.line1), \(address.city), \(address.state) \(address.zip)"
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        let urlString = "\(APIConfig.mapboxBaseURL)/geocoding/v5/mapbox.places/\(encodedQuery).json?access_token=\(apiKey)&limit=1"
        guard let url = URL(string: urlString) else {
            throw AppError.invalidAddress
        }
        
        let response: MapboxGeocodingResponse = try await apiClient.get(url: url)
        
        guard let feature = response.features.first,
              feature.geometry.coordinates.count >= 2 else {
            throw AppError.invalidAddress
        }
        
        // Check if address is accurate enough
        if let accuracy = feature.properties.accuracy, accuracy == "point" {
            // Valid address with point accuracy
            return (feature.geometry.coordinates[0], feature.geometry.coordinates[1])
        } else if feature.properties.accuracy == nil || feature.properties.accuracy == "street" {
            // Street-level accuracy is acceptable
            return (feature.geometry.coordinates[0], feature.geometry.coordinates[1])
        } else {
            // Address is too vague
            throw AppError.invalidAddress
        }
    }
    
    /// Calculates ETA using Mapbox Directions API
    private func calculateDirectionsETA(from: (Double, Double), to: (Double, Double)) async throws -> Int {
        let apiKey = APIConfig.getAPIKey(for: .mapbox)
        let urlString = "\(APIConfig.mapboxBaseURL)/directions/v5/mapbox/driving/\(from.0),\(from.1);\(to.0),\(to.1)?access_token=\(apiKey)"
        guard let url = URL(string: urlString) else {
            throw AppError.networkError("Invalid directions URL")
        }
        
        let response: MapboxDirectionsResponse = try await apiClient.get(url: url)
        
        guard let route = response.routes.first else {
            throw AppError.networkError("No route found")
        }
        
        // Convert seconds to minutes and round up
        let etaMinutes = Int(ceil(route.duration / 60.0))
        return max(etaMinutes, 5) // Minimum 5 minutes
    }
}

