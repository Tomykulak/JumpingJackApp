//
//  HomeView.swift
//  JumpingJackApp
//
//  Created by Tomáš Okruhlica on 29.12.2024.
//

import SwiftUI
import FirebaseCore

struct HomeView: View {
    @StateObject var homeViewModel: HomeViewModel
    
    var body: some View {
        NavigationStack {
            VStack(
                alignment: .leading,
                spacing: 20
            ) {
                //leaderboardHeader
                PlayerLeaderboardBox(viewModel: homeViewModel, currentUser: homeViewModel.state.user)
                
                Spacer()
                // Game Header
                gameHeader
                                
                // Play Button
                HStack {
                    PlayButton(homeViewModel: homeViewModel)
                        .frame(maxWidth: .infinity) // Center-align button
                }
                Spacer()
            }
            .padding(.top)
            .padding(.horizontal)
            .background(Color.backgroundColor)
        }
        .toolbar {
            // Leading: Profile Button
            ToolbarItem(placement: .topBarLeading) {
                ToolbarProfile(homeViewModel: homeViewModel)
            }
            
            // Trailing: Shop and Coins Display
            ToolbarItemGroup(placement: .topBarTrailing) {
                HStack(spacing: 12) {
                    ShopButton(homeViewModel: homeViewModel)
                    ToolbarCoins(homeViewModel: homeViewModel)
                }
            }
        }
        .toolbarBackground(Color.toolbarColor)
        .toolbarBackground(.visible)
        .onAppear {
            homeViewModel.send(.didAppear)
            homeViewModel.send(.fetchLeaderboard)
            if (homeViewModel.state.user.facebookId != "Unknown fb id") {
                homeViewModel.send(.saveUserToFirestore)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(false)
    }
    
    // MARK: - Game Header
    private var gameHeader: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Get Ready to Play!")
                .font(.title2)
                .bold()
                .foregroundColor(.primary)

            Text("Collect coins in game and unlock new exciting skins to customize your character!")
                .font(.caption)
                .foregroundColor(.gray)
                .multilineTextAlignment(.leading)
        }
    }
    
    // MARK: - Leaderboard Header
    private var leaderboardHeader: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Climb the Leaderboard!")
                .font(.title2)
                .bold()
                .foregroundColor(.primary)

            Text("Challenge your opponents and aim for the top score!")
                .font(.caption)
                .foregroundColor(.gray)
                .multilineTextAlignment(.leading)
        }
    }
}
