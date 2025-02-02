//
//  ScoreNode.swift
//  JumpingJackApp
//
//  Created by Adam Smekal on 06.01.2025.
//

import SpriteKit

final class ScoreNode: SKLabelNode {
    private let height: CGFloat = 26
    
    override init() {
        super.init()
        
        zPosition = Layer.labels
        
        updateText(score: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public API
extension ScoreNode {
    func updateText(score: Double) {
        let formattedScore = String(format: "%.1f", score)
        // Create shadow attributes
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.black
        shadow.shadowOffset = CGSize(width: 2, height: 2)
        shadow.shadowBlurRadius = 3.0
        
        attributedText = NSAttributedString(
            string: formattedScore + " m",
            attributes: [
                .foregroundColor: UIColor.orange,
                .font: UIFont.boldSystemFont(ofSize: height) as Any,
                .shadow: shadow
            ]
        )
    }
}
