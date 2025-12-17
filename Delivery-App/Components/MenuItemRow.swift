//
//  MenuItemRow.swift
//  Delivery-App
//
//  Created by Mike Gweth Lango on 12/10/25.
//

import SwiftUI

/// Row component for displaying a menu item with add to cart button
struct MenuItemRow: View {
    let menuItem: MenuItem
    let onAddToCart: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // Item image placeholder
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(width: 80, height: 80)
                .overlay(
                    Image(systemName: "photo")
                        .foregroundColor(.gray)
                )
                .cornerRadius(8)
            
            // Item details
            VStack(alignment: .leading, spacing: 4) {
                Text(menuItem.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                if let description = menuItem.description {
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                Text(MoneyFormat.format(cents: menuItem.priceCents))
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
            }
            
            Spacer()
            
            // Add to cart button
            Button(action: onAddToCart) {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
                    .foregroundColor(.blue)
            }
            .accessibilityIdentifier("addToCartButton")
        }
        .padding(.vertical, 8)
    }
}

