//
//  GameStateRunning.swift
//  JumpingJackApp
//
//  Created by Tomáš Okruhlica on 03.01.2025.
//

import GameplayKit

final class GameStateRunning: GKState {
    // MARK: Properties
    private unowned var gameViewController: GameViewController
    
    private(set) var score = 0.0
    private(set) var coins = 0
    private var initialPlayerPositionX: CGFloat = 0.0
    // Define conversion factor (1 pixel = 0.4 meters)
    // a sturdy kangaroo can jump up 9 meters.
    private let pixelToMeterConversion: CGFloat = 0.04
    
    // MARK: Init
    init(gameViewController: GameViewController) {
        self.gameViewController = gameViewController
    }
    
    // MARK: Overrides
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is GameStateFinished.Type || stateClass is GameStatePaused.Type
    }
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        
        // Open a new game scene only if transitioning from GameStateInitial
        if previousState is GameStatePaused {
            // Resuming the game
            print("[GAME STATE] Resumed Running")
        } else {
            gameViewController.openGameScene()
            
            if let gameScene = gameViewController.currentScene as? GameScene {
                let player = gameScene.getPlayer()
                initialPlayerPositionX = player.position.x
            }
            
        }
    }
    
    override func willExit(to nextState: GKState) {
        super.willExit(to: nextState)
        if nextState is GameStateFinished {
            score = 0
            coins = 0
        }
    }
}

// MARK: Public API
extension GameStateRunning {
    func updateScore(currentPlayerX: CGFloat) {
        let distance = currentPlayerX - initialPlayerPositionX
        score = max(0, Double(distance * pixelToMeterConversion))
    }
    
    func updateCoinsCounter() {
        coins+=1
    }
}
