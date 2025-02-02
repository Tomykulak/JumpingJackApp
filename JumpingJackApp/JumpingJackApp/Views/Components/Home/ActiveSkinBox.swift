//
//  ActiveSkinBox.swift
//  JumpingJackApp
//
//  Created by Tomáš Okruhlica on 22.01.2025.
//

import SwiftUI

struct ActiveSkinBox: View {
    @StateObject var viewModel: HomeViewModel
    private let width: CGFloat = 100
    private let height: CGFloat = 100
    var body: some View {
        VStack {
            Text("Your current skin")
                .font(.headline)
            if let activeSkin = viewModel.state.user.activeSkin {
                if activeSkin.imageName.contains("jack") {
                    // Display custom asset image
                    Image(activeSkin.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: width, height: height)
                        .padding()
                } else {
                    // Display system SF Symbol image
                    Image(systemName: activeSkin.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: width, height: height)
                        .padding()
                }
            } else {
                // Fallback for no active skin
                Image(systemName: "questionmark.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: width, height: height)
                    .padding()
            }
        }
        .padding()
    }
}
