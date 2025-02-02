//
//  PauseIconNode.swift
//  JumpingJackApp
//
//  Created by Tomáš Okruhlica on 27.01.2025.
//

import SpriteKit

final class PauseIconNode: SKNode {
    
    override init() {
        super.init()
        zPosition = Layer.labels
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Use this to create an icon to pause the game
    static func createPauseIcon() -> SKNode {
        let pauseIcon = SKNode()
        pauseIcon.name = "pauseIcon"
        
        // Create left bar
        let leftBar = SKShapeNode(rectOf: CGSize(width: 8, height: 30))
        leftBar.fillColor = .black
        leftBar.strokeColor = .clear
        leftBar.position = CGPoint(x: -12, y: 0)
        
        // Create right bar
        let rightBar = SKShapeNode(rectOf: CGSize(width: 8, height: 30))
        rightBar.fillColor = .black
        rightBar.strokeColor = .clear
        rightBar.position = CGPoint(x: 12, y: 0)
        
        // Add bars to the pause icon node
        pauseIcon.addChild(leftBar)
        pauseIcon.addChild(rightBar)
        
        return pauseIcon
    }
    
    // Use this to create an icon to resume the game
    static func createResumeIcon() -> SKNode {
        let resumeIcon = SKNode()
        resumeIcon.name = "resumeIcon"
        
        // Dimensions of the play icon matching the pause icon's width
        let iconWidth: CGFloat = 24 // Total width of the pause icon (10 + 10 + 4 spacing)
        let iconHeight: CGFloat = 30 // Same height as the pause icon
        
        // Create a triangle for the play icon
        let triangle = SKShapeNode()
        let path = CGMutablePath()
        
        // Define points for the triangle
        path.move(to: CGPoint(x: -iconWidth / 2, y: -iconHeight / 2)) // Bottom-left corner
        path.addLine(to: CGPoint(x: iconWidth / 2, y: 0))            // Tip
        path.addLine(to: CGPoint(x: -iconWidth / 2, y: iconHeight / 2)) // Top-left corner
        path.closeSubpath()
        
        triangle.path = path
        triangle.fillColor = .black
        triangle.strokeColor = .clear
        
        // Add the triangle to the resume icon node
        resumeIcon.addChild(triangle)
        
        return resumeIcon
    }

}
