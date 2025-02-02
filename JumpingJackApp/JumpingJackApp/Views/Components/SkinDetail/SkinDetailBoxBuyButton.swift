//
//  SkinDetailBoxBuyButton.swift
//  JumpingJackApp
//
//  Created by Tomáš Okruhlica on 02.01.2025.
//
import SwiftUI

struct SkinDetailBoxBuyButton: View {
    @StateObject var homeViewModel: HomeViewModel
    var skin: Skin
    @Binding var isPurchaseCompleted: Bool
    @State private var showConfirmation = false

    var body: some View {
        HStack {
            if homeViewModel.state.user.ownedSkins.contains(where: { $0.name == skin.name }) {
                Text("You already own this skin!")
                    .foregroundColor(.green)
                    .fontWeight(.bold)
            } else if homeViewModel.state.user.coins < skin.price {
                Text("Not enough coins to buy this skin.")
                    .foregroundColor(.red)
                    .fontWeight(.bold)
            } else {
                Button(action: {
                    // Show confirmation dialog
                    showConfirmation = true
                }) {
                    Text("Purchase for \(skin.price),- coins")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.playButtonColor0)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                }
                .alert("Confirm Purchase", isPresented: $showConfirmation) {
                    Button("Purchase") {
                        // Perform the purchase
                        homeViewModel.send(.didUserBuySkin(homeViewModel.state.user, skin))
                        isPurchaseCompleted = true
                    }
                    Button("Cancel", role: .cancel) {}
                } message: {
                    Text("Are you sure you want to buy \(skin.name) for \(skin.price) coins?")
                }

            }
        }
    }
}
