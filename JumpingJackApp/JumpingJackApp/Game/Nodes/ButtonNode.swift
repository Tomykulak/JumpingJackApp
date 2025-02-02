//
//  PlayGameNode.swift
//  JumpingJackApp
//
//  Created by Tomáš Okruhlica on 03.01.2025.
//

import SpriteKit

final class ButtonNode: SKSpriteNode {
    init(imageNamed: String) {
        let texture = SKTexture(imageNamed: imageNamed)
        
        super.init(
            texture: texture,
            color: .clear,
            size: CGSize(width: texture.size().width * 0.6, height: texture.size().height * 0.6)
        )
        
        zPosition = Layer.playGame
    
        addPulsingAnimation()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // added animation for button
    private func addPulsingAnimation() {
            // Run pulsing animation
            run(
                .repeatForever(
                    .sequence([
                        .scale(to: 1.1, duration: 0.6), // Scale up
                        .scale(to: 1.0, duration: 0.6)  // Scale down
                    ])
                )
            )
        }
}
