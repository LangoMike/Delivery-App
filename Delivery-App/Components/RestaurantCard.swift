//
//  RestaurantCard.swift
//  Delivery-App
//
//  Created by Mike Gweth Lango on 12/10/25.
//

import SwiftUI

/// Card component for displaying restaurant information
struct RestaurantCard: View {
    let restaurant: Restaurant
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Restaurant image placeholder
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(height: 150)
                .overlay(
                    Image(systemName: "fork.knife")
                        .font(.system(size: 40))
                        .foregroundColor(.gray)
                )
                .cornerRadius(12)
            
            // Restaurant name
            Text(restaurant.name)
                .font(.headline)
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
            
            // Cuisine type
            Text(restaurant.cuisine)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            // Rating if available
            if let rating = restaurant.rating {
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.caption)
                    Text(String(format: "%.1f", rating))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        .accessibilityIdentifier("restaurantCell")
    }
}

