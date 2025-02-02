//
//  SplashView.swift
//  JumpingJackApp
//
//  Created by Tomáš Okruhlica on 27.01.2025.
//

import SwiftUI

struct SplashView: View {
    @State private var jumpOffset: CGFloat = 0
    @State private var isJumping = false

    var body: some View {
        VStack(spacing: 20) {
            Image("jack0")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
            // Jumping text animation
            Text("Jumping Jack")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .offset(y: jumpOffset)
                .animation(
                    .easeInOut(duration: 0.5).repeatForever(autoreverses: true),
                    value: isJumping
                )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.backgroundColor0)
        .toolbarBackground(Color.toolbarColor1)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            // Start the jumping animation
            isJumping = true
            jumpOffset = -20
        }
    }
}
