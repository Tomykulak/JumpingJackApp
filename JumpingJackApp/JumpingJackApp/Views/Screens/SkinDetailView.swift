//
//  SkinDetailView.swift
//  JumpingJackApp
//
//  Created by Tomáš Okruhlica on 29.12.2024.
//

import SwiftUI

struct SkinDetailView: View {
    var skin: Skin
    @StateObject var homeViewModel: HomeViewModel
    @Environment(\.dismiss) var dismiss // Used for navigating back
    @State private var isPurchaseCompleted: Bool = false // Track purchase status

    var body: some View {
        NavigationStack {
            VStack {
                if isPurchaseCompleted {
                    // Centered checkmark with animation
                    SkinPurchaseBox {
                        // navigate back to shop
                        dismiss()
                    }
                } else {
                    SkinDetailBox(skin: skin, homeViewModel: homeViewModel, isPurchaseCompleted: $isPurchaseCompleted)
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                Spacer()
            }
            .background(Color.backgroundColor0)
            .toolbarBackground(Color.toolbarColor)
            .toolbarBackground(.visible)
        }
    }
}

