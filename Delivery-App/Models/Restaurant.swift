//
//  Restaurant.swift
//  Delivery-App
//
//  Created by Mike Gweth Lango on 12/10/25.
//

import Foundation

/// Represents a restaurant that can be ordered from
struct Restaurant: Identifiable, Codable {
    let id: String
    let name: String
    let cuisine: String
    let rating: Double?
    let imageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case cuisine
        case rating
        case imageURL = "image_url"
    }
}

