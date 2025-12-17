//
//  RestaurantsView.swift
//  Delivery-App
//
//  Created by Mike Gweth Lango on 12/10/25.
//

import SwiftUI

/// Main screen displaying list of available restaurants
struct RestaurantsView: View {
    @StateObject private var viewModel: RestaurantsViewModel
    @EnvironmentObject var cartStore: CartStore
    
    init(viewModel: RestaurantsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Loading restaurants...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let error = viewModel.error {
                ErrorStateView(error: error) {
                    Task {
                        await viewModel.loadRestaurants()
                    }
                }
            } else if viewModel.restaurants.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "fork.knife")
                        .font(.system(size: 48))
                        .foregroundColor(.gray)
                    Text("No restaurants available")
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    // Adaptive layout: grid for iPad, list for iPhone
                    let columns = [
                        GridItem(.adaptive(minimum: 300), spacing: 16)
                    ]
                    
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(viewModel.restaurants) { restaurant in
                            NavigationLink(value: restaurant) {
                                RestaurantCard(restaurant: restaurant) {
                                    // Navigation handled by NavigationLink
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("CampusEats")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(value: "cart") {
                    ZStack(alignment: .topTrailing) {
                        Image(systemName: "cart")
                            .font(.title2)
                        
                        if !cartStore.isEmpty {
                            Text("\(cartStore.items.count)")
                                .font(.caption2)
                                .foregroundColor(.white)
                                .padding(4)
                                .background(Color.red)
                                .clipShape(Circle())
                                .offset(x: 8, y: -8)
                        }
                    }
                }
                .accessibilityIdentifier("cartButton")
            }
        }
        .navigationDestination(for: Restaurant.self) { restaurant in
            MenuView(restaurant: restaurant)
                .environmentObject(cartStore)
        }
        .navigationDestination(for: String.self) { destination in
            if destination == "cart" {
                CartView()
                    .environmentObject(cartStore)
            }
        }
        .onAppear {
            Task {
                await viewModel.loadRestaurants()
            }
        }
    }
}

// Helper extension for NavigationLink with Restaurant
extension Restaurant: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Restaurant, rhs: Restaurant) -> Bool {
        lhs.id == rhs.id
    }
}

