//
//  DeliveryAddress.swift
//  Delivery-App
//
//  Created by Mike Gweth Lango on 12/10/25.
//

import Foundation

/// Represents a delivery address for an order
struct DeliveryAddress: Codable {
    let line1: String
    let city: String
    let state: String
    let zip: String
    
    /// Validates that all required fields are non-empty
    var isValid: Bool {
        !line1.trimmingCharacters(in: .whitespaces).isEmpty &&
        !city.trimmingCharacters(in: .whitespaces).isEmpty &&
        !state.trimmingCharacters(in: .whitespaces).isEmpty &&
        !zip.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    /// Returns formatted address string
    var formatted: String {
        "\(line1), \(city), \(state) \(zip)"
    }
}

