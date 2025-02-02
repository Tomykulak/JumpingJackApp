//
//  ShopSkinButton.swift
//  JumpingJackApp
//
//  Created by Tomáš Okruhlica on 30.12.2024.
//

import SwiftUI

// Template Button for a Skin in a Shop
struct ShopSkinButton: View {
    let skin: Skin
    let isOwned: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack {
                // Skin Name
                Text(skin.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                // Skin Image with consistent layout
                ZStack(alignment: .bottom) {
                    // Skin Image
                    if skin.imageName.contains("jack") {
                        Image(skin.imageName)
                            .resizable()
                            .frame(width: 50, height: 50)
                            .padding()
                    }
                    
                    // Reserved space for the badge to align images
                    Text(isOwned ? "Owned" : "")
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(4)
                        .background(isOwned ? Color.green : Color.clear)
                        .cornerRadius(4)
                        .padding([.bottom], 10)
                        .opacity(isOwned ? 1 : 0) // Hide when not owned
                }
                
                Spacer()
                
                // Price section for unowned skins
                if !isOwned {
                    HStack {
                        Image("coin0")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15, height: 15)
                            .shadow(radius: 1)
                        Text("\(skin.price),-")
                            .font(.caption)
                            .foregroundColor(.primary)
                    }
                }
            }
            .padding()
            .background(isOwned ? Color.green.opacity(0.3) : Color.gray.opacity(0.2))
            .cornerRadius(8)
            .shadow(radius: 2)
        }
        .disabled(isOwned) // Disable the button if the skin is already owned
    }
}
