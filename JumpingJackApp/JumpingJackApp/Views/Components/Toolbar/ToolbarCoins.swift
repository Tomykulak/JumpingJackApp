//
//  ToolbarCoins.swift
//  JumpingJackApp
//
//  Created by Tomáš Okruhlica on 02.01.2025.
//

import SwiftUI

struct ToolbarCoins: View {
    @StateObject var homeViewModel: HomeViewModel

    var body: some View {
        HStack(spacing: 6) {
            Image("coin0")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .shadow(radius: 1)

            Text("\(homeViewModel.state.user.coins)")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(Color.toolbarTextColor)
        }
        .padding(.vertical, 4)
    }
}
