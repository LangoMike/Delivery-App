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
    
    /// Validates address format: ZIP should not contain letters, city should not contain numbers
    var isValid: Bool {
        let trimmedLine1 = line1.trimmingCharacters(in: .whitespaces)
        let trimmedCity = city.trimmingCharacters(in: .whitespaces)
        let trimmedState = state.trimmingCharacters(in: .whitespaces)
        let trimmedZip = zip.trimmingCharacters(in: .whitespaces)
        
        // Check all fields are non-empty
        guard !trimmedLine1.isEmpty && !trimmedCity.isEmpty && !trimmedState.isEmpty && !trimmedZip.isEmpty else {
            return false
        }
        
        // ZIP code should not contain letters
        let zipContainsLetters = trimmedZip.rangeOfCharacter(from: CharacterSet.letters) != nil
        
        // City should not contain numbers
        let cityContainsNumbers = trimmedCity.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil
        
        // Address is invalid if ZIP has letters or city has numbers
        return !zipContainsLetters && !cityContainsNumbers
    }
    
    /// Returns formatted address string
    var formatted: String {
        "\(line1), \(city), \(state) \(zip)"
    }
}

