//
//  MenuViewModel.swift
//  Delivery-App
//
//  Created by Mike Gweth Lango on 12/10/25.
//

import Foundation
import SwiftUI
import Combine

/// ViewModel for the Menu screen - manages menu items for a restaurant
@MainActor
class MenuViewModel: ObservableObject {
    @Published var menuItems: [MenuItem] = []
    @Published var isLoading = false
    @Published var error: AppError?
    
    let restaurant: Restaurant
    private let menuService: MenuService
    
    init(restaurant: Restaurant, menuService: MenuService) {
        self.restaurant = restaurant
        self.menuService = menuService
    }
    
    /// Loads menu items for the restaurant
    func loadMenuItems() async {
        isLoading = true
        error = nil
        
        do {
            menuItems = try await menuService.fetchMenuItems(for: restaurant.id)
        } catch let appError as AppError {
            error = appError
        } catch {
            error = AppError.unknown
        }
        
        isLoading = false
    }
}

