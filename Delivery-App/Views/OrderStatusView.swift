//
//  OrderStatusView.swift
//  Delivery-App
//
//  Created by Mike Gweth Lango on 12/10/25.
//

import SwiftUI

/// Screen displaying order status timeline with ETA and refresh functionality
struct OrderStatusView: View {
    @EnvironmentObject var orderStore: OrderStore
    @StateObject private var viewModel: OrderStatusViewModel
    
    @State private var order: Order?
    
    init() {
        let orderService = OrderService()
        _viewModel = StateObject(wrappedValue: OrderStatusViewModel(orderService: orderService))
    }
    
    var body: some View {
        Group {
            if let order = order {
                ScrollView {
                    VStack(spacing: 24) {
                        // Order info
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Order #\(order.id.prefix(8))")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text(order.restaurantName)
                                .font(.headline)
                                .foregroundColor(.secondary)
                            
                            Text(order.address.formatted)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        
                        // Timeline
                        TimelineView(currentStage: order.stage)
                        
                        // ETA display
                        if let etaMinutes = order.etaMinutes {
                            VStack(spacing: 8) {
                                Text("Estimated Delivery")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                Text("\(etaMinutes) minutes")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.blue)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(12)
                        }
                        
                        // Refresh button
                        Button(action: {
                            Task {
                                await refreshStatus()
                            }
                        }) {
                            HStack {
                                if viewModel.isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                } else {
                                    Image(systemName: "arrow.clockwise")
                                    Text("Refresh Status")
                                }
                            }
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(8)
                        }
                        .disabled(viewModel.isLoading)
                        .accessibilityIdentifier("refreshStatusButton")
                        
                        // Error message
                        if let error = viewModel.error {
                            Text(error.errorDescription ?? "An error occurred")
                                .font(.caption)
                                .foregroundColor(.red)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.red.opacity(0.1))
                                .cornerRadius(8)
                        }
                    }
                    .padding()
                    .frame(maxWidth: UIDevice.current.userInterfaceIdiom == .pad ? 600 : .infinity)
                    .frame(maxWidth: .infinity)
                }
            } else {
                VStack(spacing: 16) {
                    Image(systemName: "doc.text")
                        .font(.system(size: 48))
                        .foregroundColor(.gray)
                    Text("No active order")
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .navigationTitle("Order Status")
        .navigationBarTitleDisplayMode(.large)
        .accessibilityIdentifier("statusScreenTitle")
        .onAppear {
            order = orderStore.currentOrder
        }
        .onChange(of: orderStore.currentOrder?.id, ) { _ in
            order = orderStore.currentOrder
        }
    }
    
    /// Refreshes the order status from the service
    private func refreshStatus() async {
        guard let order = order else { return }
        
        if let (stage, etaMinutes) = await viewModel.refreshOrderStatus(orderId: order.id) {
            orderStore.updateOrderStatus(stage: stage, etaMinutes: etaMinutes)
            self.order = orderStore.currentOrder
        }
    }
}
