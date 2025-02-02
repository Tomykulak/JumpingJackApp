//
//  CobblePlatformNode.swift
//  JumpingJackApp
//
//  Created by Adam Smekal on 02.01.2025.
//


import SpriteKit

class CobblePlatformNode: SKSpriteNode {
        
    init() {
        let texture = SKTexture(imageNamed: Assets.Textures.cobblePlatform)
        
        super.init(
            texture: texture,
            color: .clear,
            size: CGSize(width: texture.size().width * 3, height: texture.size().height)
        )
        
        zPosition = Layer.platform
        
        name = NodeName.cobblePlatform
        physicsBody?.affectedByGravity = false
//        physicsBody?.isDynamic = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
