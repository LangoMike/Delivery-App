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
    let type: String?
    
    enum CodingKeys: String, CodingKey {
        case accuracy
        case type
    }
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
        // #region agent log
        DebugLogger.log(
            location: "MapboxService.swift:geocodeAddress",
            message: "Starting geocoding",
            data: ["address": "\(address.line1), \(address.city), \(address.state) \(address.zip)"],
            hypothesisId: "A"
        )
        // #endregion
        
        let apiKey = APIConfig.getAPIKey(for: .mapbox)
        let query = "\(address.line1), \(address.city), \(address.state) \(address.zip)"
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        let urlString = "\(APIConfig.mapboxBaseURL)/geocoding/v5/mapbox.places/\(encodedQuery).json?access_token=\(apiKey)&limit=1"
        
        // #region agent log
        DebugLogger.log(
            location: "MapboxService.swift:geocodeAddress",
            message: "Geocoding URL constructed",
            data: ["url": urlString, "encodedQuery": encodedQuery],
            hypothesisId: "A"
        )
        // #endregion
        
        guard let url = URL(string: urlString) else {
            // #region agent log
            DebugLogger.log(
                location: "MapboxService.swift:geocodeAddress",
                message: "Failed to create URL",
                data: ["urlString": urlString],
                hypothesisId: "A"
            )
            // #endregion
            throw AppError.invalidAddress
        }
        
        do {
            let response: MapboxGeocodingResponse = try await apiClient.get(url: url)
            
            // #region agent log
            DebugLogger.log(
                location: "MapboxService.swift:geocodeAddress",
                message: "Geocoding response received",
                data: ["featuresCount": response.features.count],
                hypothesisId: "A"
            )
            // #endregion
            
            guard let feature = response.features.first,
                  feature.geometry.coordinates.count >= 2 else {
                // #region agent log
                DebugLogger.log(
                    location: "MapboxService.swift:geocodeAddress",
                    message: "No valid features in response",
                    data: ["featuresCount": response.features.count],
                    hypothesisId: "A"
                )
                // #endregion
                throw AppError.invalidAddress
            }
            
            // #region agent log
            DebugLogger.log(
                location: "MapboxService.swift:geocodeAddress",
                message: "Feature found",
                data: [
                    "coordinates": feature.geometry.coordinates,
                    "accuracy": feature.properties.accuracy ?? "nil"
                ],
                hypothesisId: "A"
            )
            // #endregion
            
            // Accept any coordinates returned - Mapbox geocoding is generally accurate
            // If it returns coordinates, the address is valid enough for delivery
            return (feature.geometry.coordinates[0], feature.geometry.coordinates[1])
        } catch let error as AppError {
            // #region agent log
            DebugLogger.log(
                location: "MapboxService.swift:geocodeAddress",
                message: "AppError during geocoding",
                data: ["error": error.localizedDescription],
                hypothesisId: "A"
            )
            // #endregion
            throw error
        } catch {
            // #region agent log
            DebugLogger.log(
                location: "MapboxService.swift:geocodeAddress",
                message: "Unknown error during geocoding",
                data: ["error": error.localizedDescription],
                hypothesisId: "A"
            )
            // #endregion
            throw AppError.invalidAddress
        }
    }
    
    /// Calculates ETA using Mapbox Directions API
    private func calculateDirectionsETA(from: (Double, Double), to: (Double, Double)) async throws -> Int {
        // #region agent log
        DebugLogger.log(
            location: "MapboxService.swift:calculateDirectionsETA",
            message: "Calculating directions",
            data: [
                "from": "\(from.0),\(from.1)",
                "to": "\(to.0),\(to.1)"
            ],
            hypothesisId: "A"
        )
        // #endregion
        
        let apiKey = APIConfig.getAPIKey(for: .mapbox)
        let urlString = "\(APIConfig.mapboxBaseURL)/directions/v5/mapbox/driving/\(from.0),\(from.1);\(to.0),\(to.1)?access_token=\(apiKey)"
        
        // #region agent log
        DebugLogger.log(
            location: "MapboxService.swift:calculateDirectionsETA",
            message: "Directions URL constructed",
            data: ["url": urlString],
            hypothesisId: "A"
        )
        // #endregion
        
        guard let url = URL(string: urlString) else {
            // #region agent log
            DebugLogger.log(
                location: "MapboxService.swift:calculateDirectionsETA",
                message: "Failed to create directions URL",
                data: ["urlString": urlString],
                hypothesisId: "A"
            )
            // #endregion
            throw AppError.networkError("Invalid directions URL")
        }
        
        do {
            let response: MapboxDirectionsResponse = try await apiClient.get(url: url)
            
            // #region agent log
            DebugLogger.log(
                location: "MapboxService.swift:calculateDirectionsETA",
                message: "Directions response received",
                data: ["routesCount": response.routes.count],
                hypothesisId: "A"
            )
            // #endregion
            
            guard let route = response.routes.first else {
                // #region agent log
                DebugLogger.log(
                    location: "MapboxService.swift:calculateDirectionsETA",
                    message: "No routes in response",
                    data: ["routesCount": response.routes.count],
                    hypothesisId: "A"
                )
                // #endregion
                throw AppError.networkError("No route found")
            }
            
            // Convert seconds to minutes and round up
            let etaMinutes = Int(ceil(route.duration / 60.0))
            let finalEta = max(etaMinutes, 5) // Minimum 5 minutes
            
            // #region agent log
            DebugLogger.log(
                location: "MapboxService.swift:calculateDirectionsETA",
                message: "ETA calculated",
                data: [
                    "durationSeconds": route.duration,
                    "etaMinutes": finalEta
                ],
                hypothesisId: "A"
            )
            // #endregion
            
            return finalEta
        } catch let error as AppError {
            // #region agent log
            DebugLogger.log(
                location: "MapboxService.swift:calculateDirectionsETA",
                message: "AppError during directions calculation",
                data: ["error": error.localizedDescription],
                hypothesisId: "A"
            )
            // #endregion
            throw error
        } catch {
            // #region agent log
            DebugLogger.log(
                location: "MapboxService.swift:calculateDirectionsETA",
                message: "Unknown error during directions calculation",
                data: ["error": error.localizedDescription],
                hypothesisId: "A"
            )
            // #endregion
            throw AppError.networkError("Failed to calculate directions: \(error.localizedDescription)")
        }
    }
}

