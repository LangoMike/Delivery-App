//
//  AppError.swift
//  Delivery-App
//
//  Created by Mike Gweth Lango on 12/10/25.
//

import Foundation

/// Centralized error types for the app
enum AppError: LocalizedError {
    case networkError(String)
    case decodingError(String)
    case invalidResponse
    case invalidAddress
    case emptyCart
    case apiError(String)
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .networkError(let message):
            return "Network error: \(message)"
        case .decodingError(let message):
            return "Failed to decode data: \(message)"
        case .invalidResponse:
            return "Invalid response from server"
        case .invalidAddress:
            return "Please enter a valid delivery address"
        case .emptyCart:
            return "Your cart is empty. Add items before checkout."
        case .apiError(let message):
            return "API error: \(message)"
        case .unknown:
            return "An unknown error occurred"
        }
    }
}

