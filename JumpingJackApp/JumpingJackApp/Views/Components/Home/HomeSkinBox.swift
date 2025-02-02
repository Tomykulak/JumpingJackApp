//
//  HomeSkinBox.swift
//  JumpingJackApp
//
//  Created by Tomáš Okruhlica on 30.12.2024.
//

import SwiftUI

struct HomeSkinBox: View {
    @StateObject var homeViewModel: HomeViewModel
    
    var body: some View {
        VStack {
            profileHeader
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(homeViewModel.state.user.ownedSkins.sorted(by: { $0.price < $1.price }), id: \.id) { skin in
                        Button(action: {
                            homeViewModel.send(.setUserActiveSkin(skin))
                        }) {
                            VStack {
                                if skin.imageName.contains("jack") {
                                    Image(skin.imageName)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(
                                            width: homeViewModel.state.user.activeSkin?.name == skin.name ? 100 : 80,
                                            height: homeViewModel.state.user.activeSkin?.name == skin.name ? 100 : 80
                                        )
                                        .padding()
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(
                                                    homeViewModel.state.user.activeSkin?.name == skin.name ? Color.green : Color.gray,
                                                    lineWidth: 2
                                                )
                                        )
                                        .animation(.easeInOut, value: homeViewModel.state.user.activeSkin?.name)
                                    Text(skin.name)
                                        .font(.caption)
                                        .foregroundStyle(Color.primary)
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                }

                                
                            }
                        }
                    }
                }
                
            }
            .frame(height: 150)
        }
    }
    
    // MARK: - Profile Header
    private var profileHeader: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Owned skins")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)

            Text("Tap a skin to equip it and give your character a fresh look!")
                .font(.caption)
                .foregroundColor(.gray)
                .multilineTextAlignment(.leading)

            Divider()
                .background(Color.primary.opacity(0.3))
        }
        .padding(.bottom, 10)
    }
}
