//
//  OrderService.swift
//  Delivery-App
//
//  Created by Mike Gweth Lango on 12/10/25.
//

import Foundation

/// Service for placing orders and fetching order status
class OrderService {
    private let apiClient: APIClient
    
    init(apiClient: APIClient = .shared) {
        self.apiClient = apiClient
    }
    
    /// Places an order
    /// For now simulates order placement - will be replaced with real API integration
    func placeOrder(restaurantId: String, restaurantName: String, items: [CartItem], address: DeliveryAddress, totalCents: Int, etaMinutes: Int?) async throws -> Order {
        // Simulate API delay
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        
        // Create order with received stage
        let order = Order(
            restaurantId: restaurantId,
            restaurantName: restaurantName,
            items: items,
            address: address,
            stage: .received,
            etaMinutes: etaMinutes,
            totalCents: totalCents
        )
        
        return order
    }
    
    /// Fetches current order status
    /// For now simulates status progression - will be replaced with real API integration
    func fetchOrderStatus(orderId: String) async throws -> (OrderStage, Int?) {
        // Simulate API delay
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        
        // Mock status progression based on order age
        // In real implementation, this would fetch from API
        // For demo purposes, randomly progress status
        let stages: [OrderStage] = [.received, .preparing, .outForDelivery, .delivered]
        let randomStage = stages.randomElement() ?? .received
        let etaMinutes = randomStage == .delivered ? nil : Int.random(in: 15...45)
        
        return (randomStage, etaMinutes)
    }
}

