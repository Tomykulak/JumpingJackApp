//
//  SKSceneExtension.swift
//  JumpingJackApp
//
//  Created by Tomáš Okruhlica on 03.01.2025.
//

import SpriteKit

extension SKScene {
    var center: CGPoint {
        CGPoint(
            x: size.width * 0.5,
            y: size.height * 0.5
        )
    }
    
    var safeAreaInsets: UIEdgeInsets {
        view?.safeAreaInsets ?? .zero
    }
}
