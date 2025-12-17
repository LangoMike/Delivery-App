//
//  MenuView.swift
//  Delivery-App
//
//  Created by Mike Gweth Lango on 12/10/25.
//

import SwiftUI

/// Screen displaying menu items for a selected restaurant
struct MenuView: View {
    let restaurant: Restaurant
    @StateObject private var viewModel: MenuViewModel
    @EnvironmentObject var cartStore: CartStore
    
    init(restaurant: Restaurant) {
        self.restaurant = restaurant
        let menuService = MenuService()
        _viewModel = StateObject(wrappedValue: MenuViewModel(restaurant: restaurant, menuService: menuService))
    }
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Loading menu...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let error = viewModel.error {
                ErrorStateView(error: error) {
                    Task {
                        await viewModel.loadMenuItems()
                    }
                }
            } else if viewModel.menuItems.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "list.bullet")
                        .font(.system(size: 48))
                        .foregroundColor(.gray)
                    Text("No menu items available")
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    // Adaptive layout: 2 columns on iPad, 1 column on iPhone
                    let columns = [
                        GridItem(.flexible(), spacing: 12),
                        GridItem(.flexible(), spacing: 12)
                    ]
                    
                    LazyVGrid(columns: UIDevice.current.userInterfaceIdiom == .pad ? columns : [GridItem(.flexible())], spacing: 12) {
                        ForEach(viewModel.menuItems) { menuItem in
                            MenuItemRow(menuItem: menuItem) {
                                cartStore.addItem(menuItem, restaurantName: restaurant.name)
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                }
            }
        }
        .navigationTitle(restaurant.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: CartView().environmentObject(cartStore)) {
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
        .onAppear {
            Task {
                await viewModel.loadMenuItems()
            }
        }
    }
}

