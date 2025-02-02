//
//  SkinDetailBox.swift
//  JumpingJackApp
//
//  Created by Tomáš Okruhlica on 30.12.2024.
//

import SwiftUI

struct SkinDetailBox: View {
    let skin: Skin
    @StateObject var homeViewModel: HomeViewModel
    @Binding var isPurchaseCompleted: Bool
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            VStack {
                if skin.imageName.contains("jack") {
                    Image(skin.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 400, maxHeight: 400)
                        .padding()
                        
                }
                Text(skin.name)
                    .font(.title)
                    .bold()
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackBarButton()
            }
            ToolbarItem(placement: .topBarTrailing) {
                ToolbarCoins(homeViewModel: homeViewModel)
            }
            ToolbarItem(placement: .bottomBar){
                SkinDetailBoxBuyButton(homeViewModel: homeViewModel, skin: skin, isPurchaseCompleted: $isPurchaseCompleted)
            }
        }
        .background(Color.backgroundColor0)
        .cornerRadius(10)
        .onAppear {
            // Refresh the state when this view appears
            homeViewModel.send(.didAppear)
        }
    }
}
