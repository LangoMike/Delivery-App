//
//  CartItem.swift
//  Delivery-App
//
//  Created by Mike Gweth Lango on 12/10/25.
//

import Foundation

/// Represents an item in the shopping cart with quantity and optional notes/modifiers
struct CartItem: Identifiable, Codable {
    let id: String
    let menuItem: MenuItem
    var quantity: Int
    var note: String
    
    /// Calculates the total price for this cart item (price * quantity)
    var totalCents: Int {
        menuItem.priceCents * quantity
    }
    
    init(id: String = UUID().uuidString, menuItem: MenuItem, quantity: Int = 1, note: String = "") {
        self.id = id
        self.menuItem = menuItem
        self.quantity = max(1, quantity)
        self.note = note
    }
}

