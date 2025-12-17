//
//  RestaurantsViewModel.swift
//  Delivery-App
//
//  Created by Mike Gweth Lango on 12/10/25.
//

import Foundation
import SwiftUI

/// ViewModel for the Restaurants screen - manages restaurant list state
@MainActor
class RestaurantsViewModel: ObservableObject {
    @Published var restaurants: [Restaurant] = []
    @Published var isLoading = false
    @Published var error: AppError?
    
    private let restaurantService: RestaurantService
    
    init(restaurantService: RestaurantService) {
        self.restaurantService = restaurantService
    }
    
    /// Loads restaurants from the service
    func loadRestaurants() async {
        isLoading = true
        error = nil
        
        do {
            restaurants = try await restaurantService.fetchRestaurants()
        } catch let appError as AppError {
            error = appError
        } catch {
            error = .unknown
        }
        
        isLoading = false
    }
}

