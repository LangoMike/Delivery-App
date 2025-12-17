//
//  CheckoutViewModel.swift
//  Delivery-App
//
//  Created by Mike Gweth Lango on 12/10/25.
//

import Foundation
import SwiftUI

/// ViewModel for the Checkout screen - manages address input and order placement
@MainActor
class CheckoutViewModel: ObservableObject {
    @Published var addressLine1: String = ""
    @Published var city: String = ""
    @Published var state: String = ""
    @Published var zip: String = ""
    @Published var isPlacingOrder = false
    @Published var error: AppError?
    
    private let orderService: OrderService
    private let mapboxService: MapboxService
    
    init(orderService: OrderService, mapboxService: MapboxService) {
        self.orderService = orderService
        self.mapboxService = mapboxService
    }
    
    /// Validates address fields
    var isValidAddress: Bool {
        !addressLine1.trimmingCharacters(in: .whitespaces).isEmpty &&
        !city.trimmingCharacters(in: .whitespaces).isEmpty &&
        !state.trimmingCharacters(in: .whitespaces).isEmpty &&
        !zip.trimmingCharacters(in: .whitespaces).isEmpty
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
            error = unknownError
            throw unknownError
        }
    }
}

