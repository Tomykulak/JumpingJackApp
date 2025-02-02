//
//  ShopView.swift
//  JumpingJackApp
//
//  Created by Tomáš Okruhlica on 29.12.2024.
//

import SwiftUI

struct ShopView: View {
    @StateObject var homeViewModel: HomeViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Shop Header
                    shopHeader
                    
                    // Grid layout for skins
                    LazyVGrid(
                        columns: [
                            GridItem(.flexible(), spacing: 30), // First column
                            GridItem(.flexible(), spacing: 30), // Second column
                            GridItem(.flexible(), spacing: 30)  // Third column
                        ],
                        spacing: 20 // Row spacing
                    ) {
                        // Sort available skins by price
                        ForEach(homeViewModel.state.availableSkins.sorted(by: { $0.price < $1.price })) { skin in
                            ShopSkinButton(
                                skin: skin,
                                isOwned: homeViewModel.state.user.ownedSkins.contains(where: { $0.name == skin.name })
                            ) {
                                homeViewModel.send(.didTapSkinDetailButton(skin))
                            }
                        }
                    }
                }
                .padding()
            }
            .background(Color.backgroundColor)
        }
        .navigationTitle("Shop")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackBarButton()
            }
            // Trailing: Coins Display
            ToolbarItem(placement: .topBarTrailing) {
                ToolbarCoins(homeViewModel: homeViewModel)
            }
        }
        .navigationBarHidden(false)
        .navigationBarBackButtonHidden(true)
        .toolbarBackground(Color.toolbarColor)
        .toolbarBackground(.visible)
        .onAppear {
            homeViewModel.send(.fetchAvailableSkins)
        }
    }

    // MARK: - Shop Header
    private var shopHeader: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Original Skins")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)

            Text("Browse and unlock unique skins to customize your character!")
                .font(.caption)
                .foregroundColor(.gray)
                .multilineTextAlignment(.leading)

            Divider()
                .background(Color.primary.opacity(0.3))
        }
        .padding(.bottom, 10)
    }
}
