//
//  CartStore.swift
//  Delivery-App
//
//  Created by Mike Gweth Lango on 12/10/25.
//

import Foundation
import SwiftUI

/// Single source of truth for cart state - manages cart items and provides computed totals
@MainActor
class CartStore: ObservableObject {
    @Published var items: [CartItem] = []
    @Published var restaurantName: String?
    
    /// Current restaurant ID (nil if cart is empty or mixed)
    var restaurantId: String? {
        guard let firstItem = items.first else { return nil }
        return firstItem.menuItem.restaurantId
    }
    
    /// Adds an item to the cart or increments quantity if already present
    func addItem(_ menuItem: MenuItem, quantity: Int = 1, note: String = "", restaurantName: String? = nil) {
        if let existingIndex = items.firstIndex(where: { $0.menuItem.id == menuItem.id && $0.note == note }) {
            items[existingIndex].quantity += quantity
        } else {
            let cartItem = CartItem(menuItem: menuItem, quantity: quantity, note: note)
            items.append(cartItem)
            // Set restaurant name if this is the first item
            if items.count == 1, let name = restaurantName {
                self.restaurantName = name
            }
        }
    }
    
    /// Removes an item from the cart
    func removeItem(_ cartItem: CartItem) {
        items.removeAll { $0.id == cartItem.id }
    }
    
    /// Updates the quantity of a cart item
    func updateQuantity(for cartItem: CartItem, quantity: Int) {
        guard let index = items.firstIndex(where: { $0.id == cartItem.id }) else { return }
        if quantity <= 0 {
            items.remove(at: index)
        } else {
            items[index].quantity = quantity
        }
    }
    
    /// Updates the note for a cart item
    func updateNote(for cartItem: CartItem, note: String) {
        guard let index = items.firstIndex(where: { $0.id == cartItem.id }) else { return }
        items[index].note = note
    }
    
    /// Clears all items from the cart
    func clear() {
        items.removeAll()
        restaurantName = nil
    }
    
    /// Computed properties using CartCalculator
    var subtotalCents: Int {
        CartCalculator.subtotalCents(items: items)
    }
    
    var taxCents: Int {
        CartCalculator.taxCents(subtotal: subtotalCents)
    }
    
    var deliveryFeeCents: Int {
        CartCalculator.deliveryFeeCents(subtotal: subtotalCents)
    }
    
    var totalCents: Int {
        CartCalculator.totalCents(items: items)
    }
    
    var isEmpty: Bool {
        items.isEmpty
    }
}

