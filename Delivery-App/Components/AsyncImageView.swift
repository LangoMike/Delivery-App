//
//  AsyncImageView.swift
//  Delivery-App
//
//  Created for loading remote images
//

import SwiftUI

/// Reusable component for loading images asynchronously with placeholder
struct AsyncImageView: View {
    let imageURL: String?
    let placeholder: Image
    let width: CGFloat?
    let height: CGFloat?
    
    init(imageURL: String?, placeholder: Image = Image(systemName: "photo"), width: CGFloat? = nil, height: CGFloat? = nil) {
        self.imageURL = imageURL
        self.placeholder = placeholder
        self.width = width
        self.height = height
    }
    
    var body: some View {
        Group {
            if let imageURL = imageURL, let url = URL(string: imageURL) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        placeholder
                            .foregroundColor(.gray)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .failure:
                        placeholder
                            .foregroundColor(.gray)
                    @unknown default:
                        placeholder
                            .foregroundColor(.gray)
                    }
                }
            } else {
                placeholder
                    .foregroundColor(.gray)
            }
        }
        .frame(width: width, height: height)
    }
}

