//
//  GameFinishedScene.swift
//  JumpingJackApp
//
//  Created by Adam Smekal on 07.01.2025.
//

import GameplayKit
import SpriteKit

final class GameFinishedScene: SKScene {
    private let gameState: GKStateMachine
    private var soundEffectManager: SoundEffectManager
    private let viewModel: HomeViewModel

    init(
        size: CGSize,
        gameState: GKStateMachine,
        soundEffectManager: SoundEffectManager,
        viewModel: HomeViewModel
    ) {
        self.gameState = gameState
        self.soundEffectManager = soundEffectManager
        self.viewModel = viewModel
        super.init(size: size)
    }
    
    override func willMove(from view: SKView) {
        super.willMove(from: view)
        
        scaleMode = .aspectFill
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        soundEffectManager.playSound(named: Assets.Sounds.gameOver)
        
        // Create a "Game Over" label
        let gameOverLabel = SKLabelNode(text: "Game Over")
        gameOverLabel.fontName = UIFont.boldSystemFont(ofSize: 48).fontName
        gameOverLabel.fontSize = 48
        gameOverLabel.fontColor = .black
        gameOverLabel.zPosition = 1
        gameOverLabel.horizontalAlignmentMode = .center
        gameOverLabel.verticalAlignmentMode = .center
        gameOverLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.75)
        addChild(gameOverLabel)
        
        // Buttons
        let againButtonNode = ButtonNode(imageNamed: Assets.Buttons.againButton)
        let exitGameButton = ButtonNode(imageNamed: Assets.Buttons.exitButton)
        
        againButtonNode.name = "againButton"
        exitGameButton.name = "exitButton"
        
        let background = BackgroundNode.createBackgroundNode()
        background.anchorPoint = .zero
        addChild(background)
        addChild(againButtonNode)
        addChild(exitGameButton)
        
        // Position the buttons on the screen
        againButtonNode.position = CGPoint(x: size.width / 2, y: size.height * 0.5)
        exitGameButton.position = CGPoint(x: size.width / 2, y: size.height * 0.35)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if let touch = touches.first {
            let location = touch.location(in: self)
            let nodesAtPoint = nodes(at: location)

            if nodesAtPoint.contains(where: { $0.name == "againButton" }) {
                gameState.enter(GameStateRunning.self)
            }

            if nodesAtPoint.contains(where: { $0.name == "exitButton" }) {
                viewModel.send(.redirectToHome)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
