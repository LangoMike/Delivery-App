//
//  OrderStore.swift
//  Delivery-App
//
//  Created by Mike Gweth Lango on 12/10/25.
//

import Foundation
import SwiftUI

/// Manages current order state and order history
@MainActor
class OrderStore: ObservableObject {
    @Published var currentOrder: Order?
    
    /// Sets the current order (typically after placing an order)
    func setCurrentOrder(_ order: Order) {
        currentOrder = order
    }
    
    /// Updates the current order's stage and ETA (typically after status refresh)
    func updateOrderStatus(stage: OrderStage, etaMinutes: Int?) {
        guard var order = currentOrder else { return }
        order.stage = stage
        order.etaMinutes = etaMinutes
        currentOrder = order
    }
    
    /// Clears the current order
    func clearCurrentOrder() {
        currentOrder = nil
    }
}

