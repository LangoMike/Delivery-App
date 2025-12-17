//
//  MenuItem.swift
//  Delivery-App
//
//  Created by Mike Gweth Lango on 12/10/25.
//

import Foundation

/// Represents a menu item that can be added to the cart
struct MenuItem: Identifiable, Codable {
    let id: String
    let restaurantId: String
    let name: String
    let description: String?
    let priceCents: Int
    let imageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case restaurantId = "restaurant_id"
        case name
        case description
        case priceCents = "price_cents"
        case imageURL = "image_url"
    }
}

