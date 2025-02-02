//
//  SplashView.swift
//  JumpingJackApp
//
//  Created by Tomáš Okruhlica on 29.12.2024.
//

import SwiftUI

struct LoadingView: View {
    @State private var loadingText = "Loading"
    @State private var dotCount = 0
    @State private var jumpOffset: CGFloat = 0
    @State private var isJumping = false

    var body: some View {
        VStack(spacing: 20) {
            // Jumping character animation
            Image("jack0")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .offset(y: jumpOffset) // Jumping effect
                .animation(
                    .easeInOut(duration: 0.5).repeatForever(autoreverses: true),
                    value: isJumping
                )
            
            // Loading text with animated dots
            Text("\(loadingText)\(String(repeating: ".", count: dotCount))")
                .font(.headline)
                .foregroundColor(.gray)
                .onAppear(perform: startLoadingAnimation)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.backgroundColor0)
        .toolbarBackground(Color.toolbarColor1)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            // Start jumping animation
            isJumping = true
            jumpOffset = -20
        }
    }

    private func startLoadingAnimation() {
        // Animate dots in the loading text
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            dotCount = (dotCount + 1) % 4 // Cycle through 0, 1, 2, 3 dots
        }
    }
}

