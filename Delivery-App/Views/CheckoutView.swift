//
//  CheckoutView.swift
//  Delivery-App
//
//  Created by Mike Gweth Lango on 12/10/25.
//

import SwiftUI

/// Screen for entering delivery address and placing order
struct CheckoutView: View {
    @EnvironmentObject var cartStore: CartStore
    @EnvironmentObject var orderStore: OrderStore
    @StateObject private var viewModel: CheckoutViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var showingError = false
    @State private var isPlacingOrder = false
    @State private var navigateToStatus = false
    
    init() {
        let orderService = OrderService()
        let mapboxService = MapboxService()
        _viewModel = StateObject(wrappedValue: CheckoutViewModel(orderService: orderService, mapboxService: mapboxService))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Order summary
                VStack(alignment: .leading, spacing: 8) {
                    Text("Order Summary")
                        .font(.headline)
                    
                    ForEach(cartStore.items) { item in
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("\(item.quantity)x \(item.menuItem.name)")
                                Spacer()
                                Text(MoneyFormat.format(cents: item.totalCents))
                            }
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            
                            // Display note if present
                            if !item.note.isEmpty {
                                Text("     - \(item.note)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .padding(.leading, 8)
                            }
                        }
                    }
                    
                    Divider()
                    
                    HStack {
                        Text("Total")
                            .font(.headline)
                        Spacer()
                        Text(MoneyFormat.format(cents: cartStore.totalCents))
                            .font(.headline)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                // Address form
                VStack(alignment: .leading, spacing: 16) {
                    Text("Delivery Address")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Street Address")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        TextField("123 Main St", text: $viewModel.addressLine1)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .accessibilityIdentifier("addressLine1Field")
                    }
                    
                    HStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("City")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            TextField("City", text: $viewModel.city)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .accessibilityIdentifier("cityField")
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("State")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            TextField("ST", text: $viewModel.state)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .accessibilityIdentifier("stateField")
                        }
                        .frame(width: 80)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("ZIP Code")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        TextField("12345", text: $viewModel.zip)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                            .accessibilityIdentifier("zipField")
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
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
                
                // Place order button
                Button(action: {
                    Task {
                        await placeOrder()
                    }
                }) {
                    if isPlacingOrder {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue.opacity(0.6))
                            .cornerRadius(8)
                    } else {
                        Text("Place Order")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(viewModel.isValidAddress && !cartStore.isEmpty ? Color.blue : Color.gray)
                            .cornerRadius(8)
                    }
                }
                .disabled(!viewModel.isValidAddress || cartStore.isEmpty || isPlacingOrder)
                .accessibilityIdentifier("placeOrderButton")
            }
            .padding()
            .frame(maxWidth: UIDevice.current.userInterfaceIdiom == .pad ? 600 : .infinity)
            .frame(maxWidth: .infinity)
        }
        .navigationTitle("Checkout")
        .navigationBarTitleDisplayMode(.large)
        .alert("Error", isPresented: $showingError) {
            Button("OK") { }
        } message: {
            if let error = viewModel.error {
                Text(error.errorDescription ?? "An error occurred")
            }
        }
        .navigationDestination(isPresented: $navigateToStatus) {
            OrderStatusView()
                .environmentObject(orderStore)
        }
    }
    
    /// Places the order and navigates to status screen
    private func placeOrder() async {
        guard let restaurantId = cartStore.restaurantId,
              !cartStore.items.isEmpty else {
            viewModel.error = .emptyCart
            showingError = true
            return
        }
        
        // Get restaurant name from cart store
        let restaurantName = cartStore.restaurantName ?? "Restaurant"
        
        isPlacingOrder = true
        
        do {
            let order = try await viewModel.placeOrder(
                items: cartStore.items,
                restaurantId: restaurantId,
                restaurantName: restaurantName,
                totalCents: cartStore.totalCents
            )
            
            orderStore.setCurrentOrder(order)
            cartStore.clear()
            
            // Navigate to status screen
            navigateToStatus = true
        } catch let appError as AppError {
            if appError == .invalidAddress {
                viewModel.error = AppError.apiError("Order not processed: Invalid Address")
            } else {
                viewModel.error = appError
            }
            showingError = true
        } catch {
            viewModel.error = AppError.unknown
            showingError = true
        }
        
        isPlacingOrder = false
    }
}

