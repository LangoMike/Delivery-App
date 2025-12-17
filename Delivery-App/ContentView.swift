//
//  ContentView.swift
//  Delivery-App
//
//  Created by Mike Gweth Lango on 12/10/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var cartStore: CartStore
    @EnvironmentObject var orderStore: OrderStore
    
    var body: some View {
        NavigationStack {
            RestaurantsView(viewModel: RestaurantsViewModel(restaurantService: RestaurantService()))
                .environmentObject(cartStore)
                .environmentObject(orderStore)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(CartStore())
        .environmentObject(OrderStore())
}
