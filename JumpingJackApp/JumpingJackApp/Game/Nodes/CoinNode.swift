//
//  CoinNode.swift
//  JumpingJackApp
//
//  Created by Tomáš Okruhlica on 08.01.2025.
//


import SpriteKit

final class CoinNode: SKSpriteNode {
    private var textures: [SKTexture]
    private let height: CGFloat = 20
    //private var coinSound: SKAction!
    
    // MARK: - Initializer
    init(textures: [SKTexture]) {
        self.textures = textures
        
        super.init(
            texture: textures.first,
            color: .clear,
            size: textures.first?.size() ?? .zero
        )
        
        zPosition = Layer.coin
        name = NodeName.coin
        
        setupCoinPhysics()
        runCoinAnimation()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Static Factory Method
    static func createCoinNode() -> CoinNode {
        let textures = setupCoinTextures()
        return CoinNode(textures: textures)
    }
    
    // MARK: - Setup Functions
    private static func setupCoinTextures() -> [SKTexture] {
        let textureAtlas = loadCoinTextureAtlas()
        return loadTexturesFromAtlas(textureAtlas)
    }
    
    
    private static func loadCoinTextureAtlas() -> SKTextureAtlas{
        return SKTextureAtlas(named: Assets.Textures.coin)
    }
    
    private static func loadTexturesFromAtlas(_ textureAtlas: SKTextureAtlas) -> [SKTexture] {
        return textureAtlas.textureNames
            .sorted()
            .map { textureAtlas.textureNamed($0) }
    }
    // TODO: add coin sound so that player gets feedback
    private static func loadCoinSound() -> SKAction {
        return SKAction.playSoundFileNamed(Assets.Sounds.gameOver, waitForCompletion: false)
    }
    
    private func setupCoinPhysics(){
        physicsBody = SKPhysicsBody(
            texture: texture ?? SKTexture(),
            size: texture?.size() ?? .zero
        )
        
        // TODO: Needs to setup collisions for player to get the coin on touch
        physicsBody?.friction = 0
        physicsBody?.restitution = 0
        physicsBody?.allowsRotation = false
        physicsBody?.isDynamic = false
        
        physicsBody?.categoryBitMask = Physics.CategoryBitMask.coin
        physicsBody?.collisionBitMask = Physics.CollisionBitMask.coin
        physicsBody?.contactTestBitMask = Physics.ContactTestBitMask.coin
    }
    
    private func runCoinAnimation() {
        let framesCount = textures.count

        // Create an array of SKActions with decreasing timePerFrame values
        let animationActions: [SKAction] = (0..<framesCount).map { index in
            // Gradually reduce time per frame
            let timePerFrame = 0.2 - (0.02 * Double(index))
            return SKAction.animate(
                with: [textures[index]],
                timePerFrame: max(0.05, timePerFrame), // Ensure minimum timePerFrame
                resize: false,
                restore: true
            )
        }
        
        // Combine actions into a sequence and loop forever
        let fullAnimation = SKAction.sequence(animationActions)
        run(SKAction.repeatForever(fullAnimation))
    }
    
    static func calculateProbabilityOfCoinAppearing() -> Bool {
        let randomNumber = Int.random(in: 1...9)
        return (randomNumber % 3 == 0) ? true : false
    }
    // MARK: - Public API
    
    static func spawnCoinOnGroundNode(
        groundNode: GroundNode,
        scene: SKScene
    ) -> CoinNode? {
        let coin = createCoinNode()

        coin.position = CGPoint(
            x: groundNode.position.x + groundNode.size.width / 2,
            y: groundNode.position.y + groundNode.size.height + coin.size.height * 2
        )
        
        scene.addChild(coin)        
        return coin
    }
    
    func handleCoinCollision(coin: CoinNode) {
        coin.removeFromParent()
        coin.physicsBody = nil
    }
    
    // MARK: - Coin Actions
}

