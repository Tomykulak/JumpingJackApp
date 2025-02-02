//
//  NodeName.swift
//  JumpingJackApp
//
//  Created by Adam Smekal on 01.01.2025.
//

/// Names of nodes in scene.
///
/// When you assign `name` to `SKNode`, you can easily find it with
/// function [childNode(withName: String)](https://developer.apple.com/documentation/spritekit/sknode/1483060-childnode)
/// on `SKNode` object.

enum NodeName {
    static let cobblePlatform = "cobblePlatform"
    static let player = "player"
    static let cobbleBlock = "cobbleBlock"
    static let ground = "ground"
    static let background = "background"
    static let boundary = "boundary"
    static let coin = "coin"
}
