//
//  CoinLabel.swift
//  JumpingJackApp
//
//  Created by Adam Smekal on 13.01.2025.
//

import SpriteKit

final class CoinCountLabel: SKLabelNode {
    private let height: CGFloat = 26
    
    override init() {
        super.init()
        
        zPosition = Layer.labels
        
        updateCoinLabel(coinCount: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CoinCountLabel {
    func updateCoinLabel(coinCount: Int) {
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.black
        shadow.shadowOffset = CGSize(width: 2, height: 2)
        shadow.shadowBlurRadius = 3.0
        
        attributedText = NSAttributedString(
            string: "\(coinCount)",
            attributes: [
                .foregroundColor: UIColor.yellow,
                .font: UIFont.boldSystemFont(ofSize: height) as Any,
                .shadow: shadow
            ]
        )
    }
}
