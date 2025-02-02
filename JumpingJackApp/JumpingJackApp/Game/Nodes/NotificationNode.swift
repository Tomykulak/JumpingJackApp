//
//  NotificationNode.swift
//  JumpingJackApp
//
//  Created by Tomáš Okruhlica on 21.01.2025.
//

import SpriteKit

final class NotificationNode: SKLabelNode {
    private let height: CGFloat = 16
    
    override init() {
        super.init()
        zPosition = Layer.labels
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateText(text: String) {
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.black
        shadow.shadowOffset = CGSize(width: 2, height: 2)
        shadow.shadowBlurRadius = 3.0

        attributedText = NSAttributedString(
            string: text,
            attributes: [
                .strokeColor: UIColor.black,
                .strokeWidth: -2.0,
                .foregroundColor: UIColor.black,
                .font: UIFont.boldSystemFont(ofSize: height) as Any,
                .shadow: shadow
            ]
        )
        
        run(SKAction.sequence([
            SKAction.fadeIn(withDuration: 0.3),
            SKAction.wait(forDuration: 1.5),
            SKAction.fadeOut(withDuration: 0.3)
        ]))
    }
}
