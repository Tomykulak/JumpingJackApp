//
//  GameStatePaused.swift
//  JumpingJackApp
//
//  Created by Adam Smekal on 26.01.2025.
//

import GameplayKit

final class GameStatePaused: GKState {
    private unowned var gameViewController: GameViewController
    
    init(gameViewController: GameViewController) {
        self.gameViewController = gameViewController
    }

    // MARK: Overrides
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        stateClass is GameStateRunning.Type
    }
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        gameViewController.currentScene?.isPaused = true
        print("[GAME STATE] Paused")
    }
    
    override func willExit(to nextState: GKState) {
        super.willExit(to: nextState)
        gameViewController.currentScene?.isPaused = false
        print("[GAME STATE] Resumed")
    }
}
