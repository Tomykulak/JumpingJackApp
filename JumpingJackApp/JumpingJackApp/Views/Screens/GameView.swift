//
//  GameView.swift
//  JumpingJackApp
//
//  Created by Tomáš Okruhlica on 26.12.2024.
//

import SwiftUI
import SpriteKit

struct GameView: View {
    @StateObject var homeViewModel: HomeViewModel
    var body: some View {
        NavigationStack {
            VStack {
                GameControllerToView(
                    homeViewModel: homeViewModel
                )
                    .edgesIgnoringSafeArea(.all)
            }
        }
    }
}
