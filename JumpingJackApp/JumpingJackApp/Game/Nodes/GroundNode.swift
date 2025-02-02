import SpriteKit

class GroundNode: SKSpriteNode {
    var previousPosition: CGPoint?
    private let leftRightDistance: ClosedRange<CGFloat> = 60.0...80.0
    private let holdDuration: TimeInterval = 1.6
    private var lastTouchTime: TimeInterval?
    private let idleThreshold: TimeInterval = 2.0
    
    // MARK: - Initializer
    init(texture: SKTexture) {
        super.init(
            texture: texture,
            color: .clear,
            size: texture.size()
        )

        zPosition = Layer.platform
        name = NodeName.ground

        setupGroundPhysics()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Static Factory Method
    static func createGroundNode() -> GroundNode {
        let texture = loadGroundTexture()
        let groundNode = GroundNode(texture: texture)
        return groundNode
    }

    // MARK: - Setup Functions
    private static func loadGroundTexture() -> SKTexture {
        return SKTexture(imageNamed: Assets.Textures.base)
    }

    private func setupGroundPhysics() {
        physicsBody = SKPhysicsBody(
            rectangleOf: size,
            center: CGPoint(
                x: size.width * 0.5,
                y: size.height * 0.5
            )
        )

        physicsBody?.categoryBitMask = Physics.CategoryBitMask.ground
        physicsBody?.collisionBitMask = Physics.CollisionBitMask.ground
        physicsBody?.contactTestBitMask = Physics.ContactTestBitMask.ground
        physicsBody?.friction = 0.5
        physicsBody?.isDynamic = false
        physicsBody?.affectedByGravity = false
    }

    // MARK: - Movement and Falling Logic
    func startMoving(bool: Bool) {
        let randomDistance = CGFloat.random(in: leftRightDistance)

        let moveRight = SKAction.moveBy(x: randomDistance, y: 0, duration: holdDuration)
        let moveLeft = SKAction.moveBy(x: -randomDistance, y: 0, duration: holdDuration)

        let movementSequence = SKAction.sequence([moveRight, moveLeft])
        let repeatMovement = SKAction.repeatForever(movementSequence)

        if bool {
            run(repeatMovement)
        }
    }

    func checkAndStartFalling(currentTime: TimeInterval) -> Bool {
        if let lastTouchTime = lastTouchTime, (currentTime - lastTouchTime) > idleThreshold {
            physicsBody?.isDynamic = true
            return true
        }
        return false
    }

    func setLastTouchTime(to time: TimeInterval) {
        self.lastTouchTime = time
    }

    // MARK: - Static Utility Functions
    static func spawnNextGroundNodeWithBounds(
        groundNode: GroundNode,
        scene: SKScene,
        groundNodes: inout [GroundNode],
        boundaryNodes: inout [BoundaryNode]
    ) -> GroundNode {
        let groundWidth = groundNode.size.width
        let randomXOffset = CGFloat.random(in: 50...80)
        let randomYOffset = CGFloat.random(in: -5...30)

        let newGroundPosition = CGPoint(
            x: groundNode.position.x + groundWidth + randomXOffset,
            y: groundNode.position.y + randomYOffset
        )

        let newGroundNode = createGroundNode()
        newGroundNode.position = newGroundPosition
        newGroundNode.anchorPoint = groundNode.anchorPoint
        newGroundNode.size = groundNode.size

        let newBoundaryNode = BoundaryNode.create(for: newGroundNode, withOffset: randomXOffset)
        scene.addChild(newBoundaryNode)
        scene.addChild(newGroundNode)

        groundNodes.append(newGroundNode)
        boundaryNodes.append(newBoundaryNode)

        return newGroundNode
    }

    static func removeOldestGroundNode(groundNodes: inout [GroundNode]) {
        if groundNodes.count > 3 {
            groundNodes.first?.removeFromParent()
            groundNodes.removeFirst()
        }
    }
}
