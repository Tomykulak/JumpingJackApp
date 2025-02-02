//
//  GamePausedScene.swift
//  JumpingJackApp
//
//  Created by Adam Smekal on 26.01.2025.
//

import GameplayKit
import SpriteKit

final class GamePausedScene: SKScene {
    private let gameState: GKStateMachine
    // sound
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
        // TODO: create resume button and insert it here, thx
        let resumeButton = ButtonNode(imageNamed: Assets.Buttons.startButton)
        let exitGamebutton = ButtonNode(imageNamed: Assets.Buttons.exitButton)
        
        resumeButton.name = "resumeButton"
        exitGamebutton.name = "exitButton"
        
        let background = BackgroundNode.createBackgroundNode()
        background.anchorPoint = .zero
        addChild(background)
        addChild(resumeButton)
        addChild(exitGamebutton)
        
        // set the node in the center of the screen
        resumeButton.position = CGPoint(x: center.x, y: center.y * 1.1)
        exitGamebutton.position = CGPoint(x: center.x, y: center.y * 0.8)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if let touch = touches.first {
            let location = touch.location(in: self)
            let nodesAtPoint = nodes(at: location)

            if nodesAtPoint.contains(where: { $0.name == "resumeButton" }) {
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
