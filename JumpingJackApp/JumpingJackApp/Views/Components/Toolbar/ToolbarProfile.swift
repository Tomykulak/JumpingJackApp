//
//  ToolbarProfile.swift
//  JumpingJackApp
//
//  Created by Tomáš Okruhlica on 02.01.2025.
//

import SwiftUI

struct ToolbarProfile: View {
    @StateObject var homeViewModel: HomeViewModel

    var body: some View {
        Button(action: { homeViewModel.send(.didTapProfileButton) }) {
            HStack(spacing: 8) {
                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                    .foregroundColor(Color.toolbarTextColor)
                    .padding(4)
                
                Text(homeViewModel.state.user.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color.toolbarTextColor)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
