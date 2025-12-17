//
//  MapboxService.swift
//  Delivery-App
//
//  Created by Mike Gweth Lango on 12/10/25.
//

import Foundation

/// Service for geocoding addresses and calculating ETAs using Mapbox API
class MapboxService {
    private let apiClient: APIClient
    private let apiKey: String
    
    init(apiClient: APIClient = .shared, apiKey: String = "") {
        self.apiClient = apiClient
        self.apiKey = apiKey
    }
    
    /// Validates address and calculates ETA using Mapbox geocoding
    /// Uses Mapbox API if configured, otherwise returns mock ETA
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
        
        // TODO: Implement Mapbox Geocoding API to validate address
        // TODO: Implement Mapbox Directions API to calculate ETA
        // For now, return mock ETA
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        return Int.random(in: 20...40)
    }
}

