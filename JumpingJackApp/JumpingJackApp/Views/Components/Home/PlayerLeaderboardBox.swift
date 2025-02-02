//
//  PlayerLeaderboardBox.swift
//  JumpingJackApp
//
//  Created by Tomáš Okruhlica on 22.01.2025.
//

import SwiftUI

struct PlayerLeaderboardBox: View {
    @StateObject var viewModel: HomeViewModel
    let currentUser: User // Pass the current player info here

    var body: some View {
        VStack(alignment: .center) {
            // HEADER
            HStack {
                Text("Leaderboard")
                    .font(.title)
                    .frame(maxWidth: .infinity, minHeight: 60)
                    .background(Color.leaderboardColor)
                    .foregroundColor(.primary)
            }
            // RANK / NAME / SCORE
            HStack {
                Text("Rank")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Name")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .center)
                Text("Score")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding(.horizontal)
            Divider()
            
            // Actual players
            ScrollView {
                ForEach(Array(viewModel.sortedLeaderboard.enumerated()), id: \.1.id) { index, user in
                    HStack {
                        Text("\(index + 1)")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(user.name)
                            .frame(maxWidth: .infinity, alignment: .center)
                        Text("\(user.highestScore)")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 5) // Add vertical padding for better spacing
                    Divider()
                }
            }
            .frame(maxHeight: 300)
           
            // Current player section if not on the leaderboard
            if !viewModel.sortedLeaderboard.contains(where: { $0.id == currentUser.id.uuidString }) {
                HStack {
                    Text("Your highest score: \(currentUser.highestScore)")
                        .font(.headline)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding()
            }
        }
        .background(Color.leaderboardBackgroundColor)
        .cornerRadius(10)
        .onAppear {
            viewModel
                .send(
                    .fetchLeaderboard
                ) // Fetch leaderboard when the view appears
        }
    }
}
