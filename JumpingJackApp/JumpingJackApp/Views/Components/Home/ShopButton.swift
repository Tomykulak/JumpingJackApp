//
//  ShopButton.swift
//  JumpingJackApp
//
//  Created by Tomáš Okruhlica on 04.01.2025.
//

import SwiftUI

struct ShopButton: View {
    @StateObject var homeViewModel: HomeViewModel
    
    var body: some View {
            Button(action: {
                homeViewModel.send(.didTapShopButton)
            }) {
                HStack {
                    Image(systemName: "cart.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                        .foregroundStyle(Color.toolbarTextColor)
                }
                .padding()
                .foregroundColor(.primary)
            }
    }
}
