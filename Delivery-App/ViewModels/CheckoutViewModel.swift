//
//  CheckoutViewModel.swift
//  Delivery-App
//
//  Created by Mike Gweth Lango on 12/10/25.
//

import Foundation
import SwiftUI
import Combine

/// ViewModel for the Checkout screen - manages address input and order placement
@MainActor
class CheckoutViewModel: ObservableObject {
    @Published var addressLine1: String = ""
    @Published var city: String = ""
    @Published var state: String = "VA"
    @Published var zip: String = ""
    @Published var isPlacingOrder = false
    @Published var error: AppError?
    
    private let orderService: OrderService
    private let mapboxService: MapboxService
    
    init(orderService: OrderService, mapboxService: MapboxService) {
        self.orderService = orderService
        self.mapboxService = mapboxService
    }
    
    /// Validates address fields: ZIP should not contain letters, city should not contain numbers
    var isValidAddress: Bool {
        let trimmedLine1 = addressLine1.trimmingCharacters(in: .whitespaces)
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
    
    /// Places an order with the current address and cart items
    func placeOrder(items: [CartItem], restaurantId: String, restaurantName: String, totalCents: Int) async throws -> Order {
        // Validate address
        guard isValidAddress else {
            throw AppError.invalidAddress
        }
        
        // Validate cart is not empty
        guard !items.isEmpty else {
            throw AppError.emptyCart
        }
        
        isPlacingOrder = true
        error = nil
        
        defer {
            isPlacingOrder = false
        }
        
        // Create delivery address
        let address = DeliveryAddress(
            line1: addressLine1.trimmingCharacters(in: .whitespaces),
            city: city.trimmingCharacters(in: .whitespaces),
            state: state.trimmingCharacters(in: .whitespaces),
            zip: zip.trimmingCharacters(in: .whitespaces)
        )
        
        // Validate address with Mapbox geocoding
        do {
            let etaMinutes = try await mapboxService.calculateETA(for: address)
            
            // Place order
            let order = try await orderService.placeOrder(
                restaurantId: restaurantId,
                restaurantName: restaurantName,
                items: items,
                address: address,
                totalCents: totalCents,
                etaMinutes: etaMinutes
            )
            
            return order
        } catch let appError as AppError {
            error = appError
            throw appError
        } catch {
            let unknownError = AppError.unknown
            self.error = unknownError
            throw unknownError
        }
    }
}

