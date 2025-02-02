//
//  BoundaryNode.swift
//  JumpingJackApp
//
//  Created by Adam Smekal on 06.01.2025.
//

import SpriteKit

final class BoundaryNode: SKNode {
    // MARK: - Initializer
    init(width: CGFloat) {
        super.init()
        
        setupBoundaryPhysics(width: width)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Functions
    private func setupBoundaryPhysics(width: CGFloat) {
        physicsBody = SKPhysicsBody(
            rectangleOf: CGSize(width: width, height: 1)
        )
        
        name = NodeName.boundary
        physicsBody?.isDynamic = false
        physicsBody?.friction = 0
        physicsBody?.restitution = 0
        physicsBody?.categoryBitMask = Physics.CategoryBitMask.boundary
        physicsBody?.collisionBitMask = Physics.CollisionBitMask.boundary
        physicsBody?.contactTestBitMask = Physics.ContactTestBitMask.boundary
    }

    // MARK: - Static Factory Method
    static func create(for groundNode: GroundNode, withOffset offset: CGFloat) -> BoundaryNode {
        // Calculate the total width of the boundary
        let boundaryWidth = groundNode.size.width + offset + 100

        let boundaryNode = BoundaryNode(width: boundaryWidth)

        // Position the boundary under the ground node
        boundaryNode.position = CGPoint(
            x: groundNode.position.x - offset / 2,
            y: groundNode.position.y - groundNode.size.height / 2
        )
        return boundaryNode
    }
    
    static func removeOldestBoundaryNode(
        boundaryNodes: inout [BoundaryNode]
    ) {
        if boundaryNodes.count > 3 {
            boundaryNodes.first?.removeFromParent()
            boundaryNodes.removeFirst()
        }
    }
}
