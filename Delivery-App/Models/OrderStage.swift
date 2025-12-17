//
//  OrderStage.swift
//  Delivery-App
//
//  Created by Mike Gweth Lango on 12/10/25.
//

import Foundation

/// Represents the stages of an order lifecycle
enum OrderStage: String, Codable, CaseIterable {
    case received = "received"
    case preparing = "preparing"
    case outForDelivery = "out_for_delivery"
    case delivered = "delivered"
    
    /// Human-readable display name for the stage
    var displayName: String {
        switch self {
        case .received:
            return "Order Received"
        case .preparing:
            return "Preparing"
        case .outForDelivery:
            return "Out for Delivery"
        case .delivered:
            return "Delivered"
        }
    }
}

