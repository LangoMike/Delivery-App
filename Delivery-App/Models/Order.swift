//
//  Order.swift
//  Delivery-App
//
//  Created by Mike Gweth Lango on 12/10/25.
//

import Foundation

/// Represents a placed order with status tracking
struct Order: Identifiable, Codable {
    let id: String
    let restaurantId: String
    let restaurantName: String
    let items: [CartItem]
    let address: DeliveryAddress
    var stage: OrderStage
    var etaMinutes: Int?
    let createdAt: Date
    let totalCents: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case restaurantId = "restaurant_id"
        case restaurantName = "restaurant_name"
        case items
        case address
        case stage
        case etaMinutes = "eta_minutes"
        case createdAt = "created_at"
        case totalCents = "total_cents"
    }
    
    init(id: String = UUID().uuidString,
         restaurantId: String,
         restaurantName: String,
         items: [CartItem],
         address: DeliveryAddress,
         stage: OrderStage = .received,
         etaMinutes: Int? = nil,
         createdAt: Date = Date(),
         totalCents: Int) {
        self.id = id
        self.restaurantId = restaurantId
        self.restaurantName = restaurantName
        self.items = items
        self.address = address
        self.stage = stage
        self.etaMinutes = etaMinutes
        self.createdAt = createdAt
        self.totalCents = totalCents
    }
}

