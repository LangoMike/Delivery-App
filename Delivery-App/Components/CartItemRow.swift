//
//  CartItemRow.swift
//  Delivery-App
//
//  Created by Mike Gweth Lango on 12/10/25.
//

import SwiftUI

/// Row component for displaying a cart item with quantity controls
struct CartItemRow: View {
    let cartItem: CartItem
    let onUpdateQuantity: (Int) -> Void
    let onUpdateNote: (String) -> Void
    let onRemove: () -> Void
    
    @State private var showingNoteEditor = false
    @State private var noteText: String
    
    init(cartItem: CartItem, onUpdateQuantity: @escaping (Int) -> Void, onUpdateNote: @escaping (String) -> Void, onRemove: @escaping () -> Void) {
        self.cartItem = cartItem
        self.onUpdateQuantity = onUpdateQuantity
        self.onUpdateNote = onUpdateNote
        self.onRemove = onRemove
        _noteText = State(initialValue: cartItem.note)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                // Item name and price
                VStack(alignment: .leading, spacing: 4) {
                    Text(cartItem.menuItem.name)
                        .font(.headline)
                    
                    Text(MoneyFormat.format(cents: cartItem.totalCents))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Quantity controls
                HStack(spacing: 12) {
                    Button(action: {
                        onUpdateQuantity(cartItem.quantity - 1)
                    }) {
                        Image(systemName: "minus.circle")
                            .foregroundColor(.blue)
                    }
                    
                    Text("\(cartItem.quantity)")
                        .font(.headline)
                        .frame(minWidth: 30)
                    
                    Button(action: {
                        onUpdateQuantity(cartItem.quantity + 1)
                    }) {
                        Image(systemName: "plus.circle")
                            .foregroundColor(.blue)
                    }
                }
                
                // Remove button
                Button(action: onRemove) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
            
            // Note display/edit
            if !cartItem.note.isEmpty || showingNoteEditor {
                HStack {
                    TextField("Add a note...", text: $noteText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .font(.caption)
                        .onSubmit {
                            onUpdateNote(noteText)
                            showingNoteEditor = false
                        }
                    
                    if showingNoteEditor {
                        Button("Done") {
                            onUpdateNote(noteText)
                            showingNoteEditor = false
                        }
                        .font(.caption)
                    }
                }
            } else {
                Button(action: { showingNoteEditor = true }) {
                    HStack {
                        Image(systemName: "note.text")
                            .font(.caption)
                        Text("Add note")
                            .font(.caption)
                    }
                    .foregroundColor(.blue)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

