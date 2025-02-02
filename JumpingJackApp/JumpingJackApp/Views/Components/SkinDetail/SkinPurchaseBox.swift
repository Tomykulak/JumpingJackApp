//
//  SkinPurchaseCompleted.swift
//  JumpingJackApp
//
//  Created by Tomáš Okruhlica on 04.01.2025.
//


import SwiftUI

struct SkinPurchaseBox: View {
    let onDismiss: () -> Void

    @State private var isAnimating = false

    var body: some View {
        VStack {
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(Color.playButtonColor0)
                .padding()
                .scaleEffect(isAnimating ? 1.2 : 0.8)
                .animation(
                    .easeInOut(duration: 0.6)
                        .repeatForever(autoreverses: true),
                    value: isAnimating
                )

            Text("Purchase Completed!")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color.playButtonColor0)
                .opacity(isAnimating ? 1 : 0)
                .animation(.easeIn(duration: 0.8), value: isAnimating)
        }
        // Center the content
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(
            Color.backgroundColor0
                .edgesIgnoringSafeArea(.all)
        )
        .scaleEffect(isAnimating ? 1 : 0.5)
        .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0), value: isAnimating)
        .onAppear {
            isAnimating = true // Start animations
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
                onDismiss()
            }
        }
    }
}
