//
//  GameStateFinished.swift
//  JumpingJackApp
//
//  Created by Tomáš Okruhlica on 03.01.2025.
//

import GameplayKit

final class GameStateFinished: GKState {
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
        gameViewController.openFinishedGameScene()
        print("[GAME STATE] Finished")
    }
}
