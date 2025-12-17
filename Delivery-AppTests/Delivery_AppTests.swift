//
//  Delivery_AppTests.swift
//  Delivery-AppTests
//
//  Created by Mike Gweth Lango on 12/10/25.
//

import XCTest
@testable import Delivery_App

final class Delivery_AppTests: XCTestCase {
    
    // MARK: - Test Helpers
    
    /// Creates a test menu item with specified price
    func makeMenuItem(id: String = "1", priceCents: Int) -> MenuItem {
        MenuItem(
            id: id,
            restaurantId: "rest1",
            name: "Test Item",
            description: "Test",
            priceCents: priceCents,
            imageURL: nil
        )
    }
    
    /// Creates a test cart item with specified menu item and quantity
    func makeCartItem(menuItem: MenuItem, quantity: Int = 1) -> CartItem {
        CartItem(menuItem: menuItem, quantity: quantity, note: "")
    }
    
    // MARK: - Subtotal Tests
    
    /// Tests subtotal calculation for a single item
    func testSubtotalSingleItem() throws {
        let menuItem = makeMenuItem(priceCents: 1000) // $10.00
        let cartItem = makeCartItem(menuItem: menuItem, quantity: 1)
        let items = [cartItem]
        
        let subtotal = CartCalculator.subtotalCents(items: items)
        XCTAssertEqual(subtotal, 1000, "Subtotal should be $10.00")
    }
    
    /// Tests subtotal calculation for multiple items with different quantities
    func testSubtotalMultipleItems() throws {
        let item1 = makeCartItem(menuItem: makeMenuItem(id: "1", priceCents: 1000), quantity: 2) // $20.00
        let item2 = makeCartItem(menuItem: makeMenuItem(id: "2", priceCents: 1500), quantity: 1) // $15.00
        let item3 = makeCartItem(menuItem: makeMenuItem(id: "3", priceCents: 500), quantity: 3)  // $15.00
        let items = [item1, item2, item3]
        
        let subtotal = CartCalculator.subtotalCents(items: items)
        XCTAssertEqual(subtotal, 5000, "Subtotal should be $50.00")
    }
    
    /// Tests subtotal for empty cart
    func testSubtotalEmptyCart() throws {
        let items: [CartItem] = []
        let subtotal = CartCalculator.subtotalCents(items: items)
        XCTAssertEqual(subtotal, 0, "Subtotal should be 0 for empty cart")
    }
    
    // MARK: - Tax Tests
    
    /// Tests tax calculation with proper rounding
    func testTaxCalculation() throws {
        let subtotal = 1000 // $10.00
        let tax = CartCalculator.taxCents(subtotal: subtotal)
        // 8% of $10.00 = $0.80 = 80 cents
        XCTAssertEqual(tax, 80, "Tax should be 80 cents for $10.00 subtotal")
    }
    
    /// Tests tax rounding (should round to nearest cent)
    func testTaxRounding() throws {
        let subtotal = 1001 // $10.01
        let tax = CartCalculator.taxCents(subtotal: subtotal)
        // 8% of $10.01 = $0.8008 = rounds to 80 cents
        XCTAssertEqual(tax, 80, "Tax should round to 80 cents")
    }
    
    /// Tests tax for zero subtotal
    func testTaxZeroSubtotal() throws {
        let tax = CartCalculator.taxCents(subtotal: 0)
        XCTAssertEqual(tax, 0, "Tax should be 0 for zero subtotal")
    }
    
    // MARK: - Delivery Fee Tests
    
    /// Tests delivery fee for order below threshold
    func testDeliveryFeeBelowThreshold() throws {
        let subtotal = 3000 // $30.00 (below $50 threshold)
        let fee = CartCalculator.deliveryFeeCents(subtotal: subtotal)
        XCTAssertEqual(fee, 500, "Delivery fee should be $5.00 for orders below threshold")
    }
    
    /// Tests free delivery for order at threshold
    func testDeliveryFeeAtThreshold() throws {
        let subtotal = 5000 // $50.00 (at threshold)
        let fee = CartCalculator.deliveryFeeCents(subtotal: subtotal)
        XCTAssertEqual(fee, 0, "Delivery fee should be free at threshold")
    }
    
    /// Tests free delivery for order above threshold
    func testDeliveryFeeAboveThreshold() throws {
        let subtotal = 6000 // $60.00 (above threshold)
        let fee = CartCalculator.deliveryFeeCents(subtotal: subtotal)
        XCTAssertEqual(fee, 0, "Delivery fee should be free above threshold")
    }
    
    // MARK: - Total Tests
    
    /// Tests total calculation equals subtotal + tax + delivery fee
    func testTotalCalculation() throws {
        let item1 = makeCartItem(menuItem: makeMenuItem(id: "1", priceCents: 2000), quantity: 1) // $20.00
        let item2 = makeCartItem(menuItem: makeMenuItem(id: "2", priceCents: 1500), quantity: 2) // $30.00
        let items = [item1, item2]
        
        let subtotal = CartCalculator.subtotalCents(items: items) // $50.00 = 5000 cents
        let tax = CartCalculator.taxCents(subtotal: subtotal) // 8% = 400 cents
        let delivery = CartCalculator.deliveryFeeCents(subtotal: subtotal) // Free = 0 cents
        let total = CartCalculator.totalCents(items: items)
        
        XCTAssertEqual(total, subtotal + tax + delivery, "Total should equal subtotal + tax + delivery")
        XCTAssertEqual(total, 5400, "Total should be $54.00")
    }
    
    /// Tests total with delivery fee included (below threshold)
    func testTotalWithDeliveryFee() throws {
        let item = makeCartItem(menuItem: makeMenuItem(priceCents: 2000), quantity: 1) // $20.00
        let items = [item]
        
        let subtotal = CartCalculator.subtotalCents(items: items) // $20.00 = 2000 cents
        let tax = CartCalculator.taxCents(subtotal: subtotal) // 8% = 160 cents
        let delivery = CartCalculator.deliveryFeeCents(subtotal: subtotal) // $5.00 = 500 cents
        let total = CartCalculator.totalCents(items: items)
        
        XCTAssertEqual(total, subtotal + tax + delivery, "Total should include delivery fee")
        XCTAssertEqual(total, 2660, "Total should be $26.60")
    }
    
    
    // MARK: - Quantity Update Tests
    
    /// Tests that quantity updates affect totals correctly
    func testQuantityUpdateAffectsTotals() throws {
        let menuItem = makeMenuItem(priceCents: 1000) // $10.00
        var cartItem = makeCartItem(menuItem: menuItem, quantity: 1)
        
        let total1 = CartCalculator.totalCents(items: [cartItem])
        XCTAssertEqual(total1, 1080 + 500, "Total with 1 item should include tax and delivery")
        
        cartItem.quantity = 2
        let total2 = CartCalculator.totalCents(items: [cartItem])
        XCTAssertEqual(total2, 2160 + 500, "Total with 2 items should be double subtotal plus tax and delivery")
        
        cartItem.quantity = 5 // $50.00 - should trigger free delivery
        let total3 = CartCalculator.totalCents(items: [cartItem])
        XCTAssertEqual(total3, 5400, "Total with 5 items should have free delivery")
    }
}
