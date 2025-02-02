//
//  Layer.swift
//  JumpingJackApp
//
//  Created by Adam Smekal on 01.01.2025.
//

import CoreGraphics

/// Definition of the Z position of the objects, which means depth of the objects in scene.
/// `SKNodes` with higher value are going to overlap the nodes with smaller one.
enum Layer {
    static let background: CGFloat = 0
    static let obstacle: CGFloat = 1
    static let coin: CGFloat = 1
    static let player: CGFloat = 2
    static let platform: CGFloat = 2
    static let playGame: CGFloat = 3
    static let labels: CGFloat = 3
}
