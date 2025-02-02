//
//  GameControllerToView.swift
//  JumpingJackApp
//
//  Created by Adam Smekal on 01.01.2025.
//

import SwiftUI

struct GameControllerToView: UIViewControllerRepresentable {
    let homeViewModel: HomeViewModel
    func makeUIViewController(context: Context) -> GameViewController {
        return GameViewController(
            homeViewModel: homeViewModel
        )
    }

    func updateUIViewController(_ uiViewController: GameViewController, context: Context) {
        // Zde můžete aktualizovat view controller, pokud je to potřeba
    }
}
