//
//  PlayGameButton.swift
//  JumpingJackApp
//
//  Created by Tomáš Okruhlica on 04.01.2025.
//

import SwiftUI

struct PlayButton: View {
    @StateObject var homeViewModel: HomeViewModel
    
    var body: some View {
        Button(action: {
            homeViewModel.send(.didTapGameButton)
        }) {
            HStack {
                /*
                Image(systemName: "gamecontroller.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundStyle(Color.black)
                */
                Text("Play")
                    .foregroundStyle(Color.black)
                    .font(.title)
            }
            .frame(maxWidth: .infinity, maxHeight: 40)
            .padding()
            .foregroundColor(.white)
            .background(Color.playButton)
            .cornerRadius(10)
        }
    }
}
