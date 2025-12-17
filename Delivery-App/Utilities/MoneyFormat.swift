//
//  MoneyFormat.swift
//  Delivery-App
//
//  Created by Mike Gweth Lango on 12/10/25.
//

import Foundation

/// Utility for formatting money values stored as Int cents
struct MoneyFormat {
    /// Converts cents to formatted currency string (e.g., 1999 -> "$19.99")
    static func format(cents: Int) -> String {
        let dollars = cents / 100
        let centsRemainder = cents % 100
        return String(format: "$%d.%02d", dollars, centsRemainder)
    }
    
    /// Converts cents to Double dollars for calculations (if needed)
    static func dollars(from cents: Int) -> Double {
        Double(cents) / 100.0
    }
}

