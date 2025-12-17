//
//  Delivery_AppUITests.swift
//  Delivery-AppUITests
//
//  Created by Mike Gweth Lango on 12/10/25.
//

import XCTest

final class Delivery_AppUITests: XCTestCase {

    override func setUpWithError() throws {
        // Stop immediately when a failure occurs
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        // Clean up after each test
    }

    /// Tests the complete order flow: select restaurant -> add item -> cart -> checkout -> place order -> verify status
    @MainActor
    func testCompleteOrderFlow() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Wait for restaurants to load
        let restaurantsScreen = app.navigationBars["CampusEats"]
        XCTAssertTrue(restaurantsScreen.waitForExistence(timeout: 5), "Restaurants screen should be visible")
        
        // Step 1: Select a restaurant
        let restaurantCell = app.buttons["restaurantCell"].firstMatch
        XCTAssertTrue(restaurantCell.waitForExistence(timeout: 5), "Restaurant cell should exist")
        restaurantCell.tap()
        
        let app = XCUIApplication()
        app.activate()
        app/*@START_MENU_TOKEN@*/.buttons["Pizza Palace, Italian, 4.5"]/*[[".buttons",".containing(.staticText, identifier: \"Italian\")",".matching(identifier: \"restaurantCell-restaurantCell-restaurantCell-restaurantCell-restaurantCell\").containing(.staticText, identifier: \"Pizza Palace\")",".containing(.staticText, identifier: \"Pizza Palace\")",".otherElements.buttons[\"Pizza Palace, Italian, 4.5\"]",".buttons[\"Pizza Palace, Italian, 4.5\"]"],[[[-1,5],[-1,4],[-1,0,1]],[[-1,3],[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
        app.buttons.matching(identifier: "addToCartButton").element(boundBy: 0).tap()
        app/*@START_MENU_TOKEN@*/.images["cart"]/*[[".buttons",".images",".images[\"Shopping Cart\"]",".images[\"cart\"]"],[[[-1,3],[-1,2],[-1,0,1]],[[-1,3],[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
        app/*@START_MENU_TOKEN@*/.buttons["checkoutButton"]/*[[".otherElements",".buttons[\"Checkout\"]",".buttons[\"checkoutButton\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
        app/*@START_MENU_TOKEN@*/.buttons["BackButton"]/*[[".navigationBars",".buttons",".buttons[\"Pizza Palace\"]",".buttons[\"BackButton\"]"],[[[-1,3],[-1,2],[-1,0,1]],[[-1,3],[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.firstMatch.doubleTap()
        // Wait for menu to load
        let menuScreen = app.navigationBars.firstMatch
        XCTAssertTrue(menuScreen.waitForExistence(timeout: 5), "Menu screen should be visible")
        
        // Step 2: Add an item to cart
        let addToCartButton = app.buttons["addToCartButton"].firstMatch
        XCTAssertTrue(addToCartButton.waitForExistence(timeout: 5), "Add to cart button should exist")
        addToCartButton.tap()
        
        // Step 3: Go to cart
        let cartButton = app.buttons["cartButton"]
        XCTAssertTrue(cartButton.waitForExistence(timeout: 2), "Cart button should exist")
        cartButton.tap()
        
        // Verify cart screen
        let cartScreen = app.navigationBars["Cart"]
        XCTAssertTrue(cartScreen.waitForExistence(timeout: 5), "Cart screen should be visible")
        
        // Step 4: Go to checkout
        let checkoutButton = app.buttons["checkoutButton"]
        XCTAssertTrue(checkoutButton.waitForExistence(timeout: 2), "Checkout button should exist")
        checkoutButton.tap()
        
        // Verify checkout screen
        let checkoutScreen = app.navigationBars["Checkout"]
        XCTAssertTrue(checkoutScreen.waitForExistence(timeout: 5), "Checkout screen should be visible")
        
        // Step 5: Enter address
        let addressLine1Field = app.textFields["addressLine1Field"]
        XCTAssertTrue(addressLine1Field.waitForExistence(timeout: 2), "Address line 1 field should exist")
        addressLine1Field.tap()
        addressLine1Field.typeText("123 Main Street")
        
        let cityField = app.textFields["cityField"]
        XCTAssertTrue(cityField.waitForExistence(timeout: 2), "City field should exist")
        cityField.tap()
        cityField.typeText("Blacksburg")
        
        let stateField = app.textFields["stateField"]
        XCTAssertTrue(stateField.waitForExistence(timeout: 2), "State field should exist")
        stateField.tap()
        stateField.typeText("VA")
        
        let zipField = app.textFields["zipField"]
        XCTAssertTrue(zipField.waitForExistence(timeout: 2), "ZIP field should exist")
        zipField.tap()
        zipField.typeText("24060")
        
        // Step 6: Place order
        let placeOrderButton = app.buttons["placeOrderButton"]
        XCTAssertTrue(placeOrderButton.waitForExistence(timeout: 2), "Place order button should exist")
        XCTAssertTrue(placeOrderButton.isEnabled, "Place order button should be enabled")
        placeOrderButton.tap()
        
        // Wait for order to be placed (may take a moment)
        let statusScreenTitle = app.navigationBars["Order Status"]
        XCTAssertTrue(statusScreenTitle.waitForExistence(timeout: 10), "Status screen should appear after placing order")
        
        // Step 7: Verify status screen is visible
        let refreshStatusButton = app.buttons["refreshStatusButton"]
        XCTAssertTrue(refreshStatusButton.waitForExistence(timeout: 5), "Refresh status button should exist on status screen")
        
        // Verify status screen title
        XCTAssertTrue(statusScreenTitle.exists, "Status screen title should be visible")
    }
}
