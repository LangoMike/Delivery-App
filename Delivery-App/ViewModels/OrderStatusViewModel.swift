//
//  OrderStatusViewModel.swift
//  Delivery-App
//
//  Created by Mike Gweth Lango on 12/10/25.
//

import Foundation
import SwiftUI
import Combine

/// ViewModel for the Order Status screen - manages order status updates
@MainActor
class OrderStatusViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var error: AppError?
    
    private let orderService: OrderService
    
    init(orderService: OrderService) {
        self.orderService = orderService
    }
    
    /// Refreshes order status from the service
    func refreshOrderStatus(orderId: String) async -> (OrderStage, Int?)? {
        isLoading = true
        error = nil
        
        defer {
            isLoading = false
        }
        
        do {
            let (stage, etaMinutes) = try await orderService.fetchOrderStatus(orderId: orderId)
            return (stage, etaMinutes)
        } catch let appError as AppError {
            error = appError
            return nil
        } catch {
            self.error = AppError.unknown
            return nil
        }
    }
}

