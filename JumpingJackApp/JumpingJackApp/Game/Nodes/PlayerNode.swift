//
//  PlayerNode.swift
//  JumpingJackApp
//
//  Created by Adam Smekal on 01.01.2025.
//

import SpriteKit

final class PlayerNode: SKSpriteNode {
    private(set) var isOnGround = true
    private let jumpingEffect: SKEmitterNode
    private let cycleDuration: TimeInterval = 1.0
    private let maxJumpHeight: CGFloat = 85.0
    private let minJumpHeight: CGFloat = 55.0
    private var jumpVelocityBar: SKSpriteNode
    private var textures: [SKTexture]

    var holdStartTime: TimeInterval?

    // MARK: - Initializer
    init(
        textures: [SKTexture],
        jumpingEffect: SKEmitterNode,
        jumpVelocityBar: SKSpriteNode
    ) {
        self.textures = textures
        self.jumpingEffect = jumpingEffect
        self.jumpVelocityBar = jumpVelocityBar

        super.init(
            texture: textures.first,
            color: .clear,
            size: textures.first?.size() ?? .zero
        )

        zPosition = Layer.player
        name = NodeName.player

        setupPlayerPhysics()
        runPlayerAnimation()
        addJumpingEffect(jumpingEffect)
        addJumpVelocityBar(jumpVelocityBar)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Static Factory Method
    static func createPlayerNode(for user: User) -> PlayerNode {
        let textures = setupPlayerTextures(for: user.activeSkin)
        let jumpingEffect = setupJumpingEffectNode()
        let jumpVelocityBar = setupJumpVelocityBarNode()
        return PlayerNode(
            textures: textures,
            jumpingEffect: jumpingEffect,
            jumpVelocityBar: jumpVelocityBar
        )
    }

    // MARK: - Setup Functions
    private static func setupPlayerTextures(for skin: Skin?) -> [SKTexture] {
        // Determine the atlas name based on the active skin
        let atlasName: String
        switch skin?.name {
        case "Skin 2":
            atlasName = "jackIdle1"
        case "Skin 3":
            atlasName = "jackIdle2"
        default:
            atlasName = "jackIdle0" // Default skin
        }

        let textureAtlas = SKTextureAtlas(named: atlasName)
        return textureAtlas.textureNames
            .sorted()
            .map { textureAtlas.textureNamed($0) }
    }

    private static func setupJumpingEffectNode() -> SKEmitterNode {
        let jumpingEffect = SKEmitterNode(fileNamed: "JumpingEffect")!
        jumpingEffect.isHidden = true
        return jumpingEffect
    }

    private static func setupJumpVelocityBarNode() -> SKSpriteNode {
        let bar = SKSpriteNode(color: .green, size: CGSize(width: 100, height: 10))
        bar.position.y = 20
        bar.isHidden = true
        return bar
    }

    private func setupPlayerPhysics() {
        physicsBody = SKPhysicsBody(
            texture: texture ?? SKTexture(),
            size: texture?.size() ?? .zero
        )

        physicsBody?.categoryBitMask = Physics.CategoryBitMask.player
        physicsBody?.collisionBitMask = Physics.CollisionBitMask.player
        physicsBody?.contactTestBitMask = Physics.ContactTestBitMask.player
        physicsBody?.friction = 1
        physicsBody?.restitution = 0
        physicsBody?.allowsRotation = false
    }

    private func runPlayerAnimation() {
        run(
            SKAction.repeatForever(
                SKAction.animate(
                    with: textures,
                    timePerFrame: 0.3,
                    resize: false,
                    restore: true
                )
            )
        )
    }

    private func addJumpingEffect(_ effect: SKEmitterNode) {
        addChild(effect)
    }

    private func addJumpVelocityBar(_ bar: SKSpriteNode) {
        addChild(bar)
    }

    // MARK: - Player Actions
    func isTouchingGround(ground: GroundNode) -> Bool {
        let playerRect = calculateAccumulatedFrame()
        let groundRect = ground.calculateAccumulatedFrame()

        let playerBottom = playerRect.minY
        let groundTop = groundRect.maxY
        let playerLeft = playerRect.minX
        let playerRight = playerRect.maxX
        let groundLeft = groundRect.minX
        let groundRight = groundRect.maxX

        let verticalProximity = abs(playerBottom - groundTop) < 30 // Adjust threshold for "top" check
        let horizontalAlignment = playerRight > groundLeft && playerLeft < groundRight

        if verticalProximity && horizontalAlignment {
            // Check only if the player is on top of the ground
            return true
        }
        return false
    }

    func makeJump(holdDuration: TimeInterval) {
        guard isOnGround else { return }

        let oscillatingTime = abs(sin((holdDuration / cycleDuration) * .pi)) * cycleDuration
        let jumpHeight = minJumpHeight + CGFloat(oscillatingTime) * (maxJumpHeight - minJumpHeight) / CGFloat(cycleDuration)
        let cappedJumpHeight = min(max(jumpHeight, minJumpHeight), maxJumpHeight)

        physicsBody?.applyImpulse(
            CGVector(dx: size.width, dy: cappedJumpHeight)
        )

        updateJumpVelocityBar(jumpHeight: cappedJumpHeight)
        toggleJumpVelocityBar(visible: false)

        jumpingEffect.isHidden = false

        let hideEffectAction = SKAction.run { [weak self] in
            self?.jumpingEffect.isHidden = true
        }
        let delayAction = SKAction.wait(forDuration: 0.1)
        run(SKAction.sequence([delayAction, hideEffectAction]))

        isOnGround = false
    }

    func handleJumpBar(touchesBegan: Bool, currentTime: TimeInterval? = nil) {
        if touchesBegan {
            guard isOnGround else {
                toggleJumpVelocityBar(visible: false)
                holdStartTime = nil
                return
            }
            holdStartTime = currentTime
            toggleJumpVelocityBar(visible: true)
        } else if let holdStartTime = holdStartTime, let currentTime = currentTime, isOnGround {
            let holdDuration = currentTime - holdStartTime
            updateJumpVelocityBarRealTime(holdDuration: holdDuration)
        } else {
            toggleJumpVelocityBar(visible: false)
            holdStartTime = nil
        }
    }

    private func toggleJumpVelocityBar(visible: Bool) {
        jumpVelocityBar.isHidden = !visible
    }

    private func updateJumpVelocityBarRealTime(holdDuration: TimeInterval) {
        let oscillatingTime = abs(sin((holdDuration / cycleDuration) * .pi)) * cycleDuration
        let jumpHeight = minJumpHeight + CGFloat(oscillatingTime) * (maxJumpHeight - minJumpHeight) / CGFloat(cycleDuration)
        updateJumpVelocityBar(jumpHeight: jumpHeight)
    }

    private func updateJumpVelocityBar(jumpHeight: CGFloat) {
        let normalizedHeight = (jumpHeight - minJumpHeight) / (maxJumpHeight - minJumpHeight)
        let barWidth = normalizedHeight * 100.0
        jumpVelocityBar.size.width = barWidth

        if normalizedHeight > 0.75 {
            jumpVelocityBar.color = .red
        } else if normalizedHeight > 0.5 {
            jumpVelocityBar.color = .yellow
        } else {
            jumpVelocityBar.color = .green
        }
    }

    func setOnGround(_ value: Bool) {
        isOnGround = value
    }

    func updatePlayerPositionWithGroundMovement(activeGround: GroundNode?) {
        guard isOnGround, let activeGround = activeGround else { return }

        let groundDeltaX = activeGround.position.x - (activeGround.previousPosition?.x ?? activeGround.position.x)
        let groundDeltaY = activeGround.position.y - (activeGround.previousPosition?.y ?? activeGround.position.y)

        position.x += groundDeltaX
        position.y += groundDeltaY

        activeGround.previousPosition = activeGround.position
    }
}
