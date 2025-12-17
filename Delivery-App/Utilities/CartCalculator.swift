//
//  CartCalculator.swift
//  Delivery-App
//
//  Created by Mike Gweth Lango on 12/10/25.
//

import Foundation

/// Centralized cart calculation logic - single source of truth for cart totals
struct CartCalculator {
    /// Tax rate as a decimal (e.g., 0.08 for 8%)
    static let taxRate: Double = 0.08
    
    /// Delivery fee threshold in cents - orders above this amount get free delivery
    static let freeDeliveryThreshold: Int = 5000 // $50.00
    
    /// Fixed delivery fee in cents
    static let deliveryFeeCents: Int = 500 // $5.00
    
    /// Calculates subtotal from cart items
    static func subtotalCents(items: [CartItem]) -> Int {
        items.reduce(0) { $0 + $1.totalCents }
    }
    
    /// Calculates tax amount with proper rounding
    static func taxCents(subtotal: Int) -> Int {
        let taxDouble = Double(subtotal) * taxRate
        return Int(round(taxDouble))
    }
    
    /// Calculates delivery fee based on subtotal threshold
    static func deliveryFeeCents(subtotal: Int) -> Int {
        if subtotal >= freeDeliveryThreshold {
            return 0
        }
        return deliveryFeeCents
    }
    
    /// Calculates total (subtotal + tax + delivery fee)
    static func totalCents(items: [CartItem]) -> Int {
        let subtotal = subtotalCents(items: items)
        let tax = taxCents(subtotal: subtotal)
        let delivery = deliveryFeeCents(subtotal: subtotal)
        return subtotal + tax + delivery
    }
}

