//
//  CartView.swift
//  Delivery-App
//
//  Created by Mike Gweth Lango on 12/10/25.
//

import SwiftUI

/// Screen displaying cart items with totals and checkout button
struct CartView: View {
    @EnvironmentObject var cartStore: CartStore
    
    var body: some View {
        Group {
            if cartStore.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "cart")
                        .font(.system(size: 48))
                        .foregroundColor(.gray)
                    Text("Your cart is empty")
                        .font(.title2)
                        .foregroundColor(.secondary)
                    Text("Add items from the menu to get started")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                VStack(spacing: 0) {
                    // Cart items list
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(cartStore.items) { cartItem in
                                CartItemRow(
                                    cartItem: cartItem,
                                    onUpdateQuantity: { newQuantity in
                                        cartStore.updateQuantity(for: cartItem, quantity: newQuantity)
                                    },
                                    onUpdateNote: { newNote in
                                        cartStore.updateNote(for: cartItem, note: newNote)
                                    },
                                    onRemove: {
                                        cartStore.removeItem(cartItem)
                                    }
                                )
                                .padding(.horizontal)
                            }
                        }
                        .padding(.vertical)
                    }
                    
                    // Totals section - adaptive width for iPad
                    VStack(spacing: 12) {
                        Divider()
                        
                        HStack {
                            Text("Subtotal")
                            Spacer()
                            Text(MoneyFormat.format(cents: cartStore.subtotalCents))
                        }
                        
                        HStack {
                            Text("Tax")
                            Spacer()
                            Text(MoneyFormat.format(cents: cartStore.taxCents))
                        }
                        
                        HStack {
                            Text("Delivery Fee")
                            Spacer()
                            if cartStore.deliveryFeeCents == 0 {
                                Text("FREE")
                                    .foregroundColor(.green)
                                    .fontWeight(.semibold)
                            } else {
                                Text(MoneyFormat.format(cents: cartStore.deliveryFeeCents))
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
                        
                        NavigationLink(destination: CheckoutView().environmentObject(cartStore)) {
                            Text("Checkout")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(8)
                        }
                        .accessibilityIdentifier("checkoutButton")
                        .padding(.top, 8)
                    }
                    .padding()
                    .frame(maxWidth: UIDevice.current.userInterfaceIdiom == .pad ? 600 : .infinity)
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemBackground))
                }
            }
        }
        .navigationTitle("Cart")
        .navigationBarTitleDisplayMode(.large)
    }
}

