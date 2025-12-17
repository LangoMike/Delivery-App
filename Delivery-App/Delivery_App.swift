//
//  Delivery_App.swift
//  Delivery-App
//
//  Created by Mike Gweth Lango on 12/10/25.
//

import SwiftUI

@main
struct Delivery_AppApp: App {
    // Initialize shared stores
    @StateObject private var cartStore = CartStore()
    @StateObject private var orderStore = OrderStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(cartStore)
                .environmentObject(orderStore)
        }
    }
}
