//
//  Physics.swift
//  JumpingJackApp
//
//  Created by Adam Smekal on 01.01.2025.
//

enum Physics {}

// MARK: CategoryBitMask
extension Physics {
    /// Defines what physics category the body belongs to.
    /// Every physics body in a scene can be assigned to up to 32 different categories,
    /// each corresponding to a bit in the bit mask. You define the mask values
    /// used in your game. In conjunction with the `collisionBitMask` and `contactTestBitMask`
    /// properties, you define which physics bodies interact with each other and when your
    /// game is notified of these interactions.
    enum CategoryBitMask {
        static let ground: UInt32 = 0b1
        static let player: UInt32 = 0b10
        static let boundary: UInt32 = 0b100
        static let coin: UInt32 = 0b1000
    }
}

// MARK: CollisionBitMask
extension Physics {
    /// A mask that defines which categories of physics bodies can collide with this physics body.
    /// When two physics bodies contact each other, a collision may occur.
    /// This body’s collision mask is compared to the other body’s category
    /// mask by performing a logical AND operation. If the result is a nonzero value,
    /// this body is affected by the collision.
    enum CollisionBitMask {
        static let ground: UInt32 = Physics.CategoryBitMask.player
        static let player: UInt32 = Physics.CategoryBitMask.ground
        static let boundary = Physics.CategoryBitMask.player
        static let coin: UInt32 = Physics.CategoryBitMask.player
    }
}

// MARK: ContactTestBitMask
extension Physics {
    /// A mask that defines which categories of physics bodies cause intersection
    /// notifications with this physics body. When two bodies share the same space,
    /// each body’s category mask is tested against the other body’s contact mask
    /// by performing a logical AND operation. If either comparison results
    /// in a nonzero value, an SKPhysicsContact object is created
    /// and passed to the physics world’s delegate.
    enum ContactTestBitMask {
        static let ground = Physics.CategoryBitMask.player
        static let player = Physics.CategoryBitMask.ground
        | Physics.CategoryBitMask.player
        | Physics.CategoryBitMask.boundary
        | Physics.CategoryBitMask.coin
        static let boundary = Physics.CategoryBitMask.player
        static let coin = Physics.CategoryBitMask.player
        
    }
}

