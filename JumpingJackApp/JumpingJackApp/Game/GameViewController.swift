//
//  GameViewController.swift
//  JumpingJackApp
//
//  Created by Adam Smekal on 01.01.2025.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation

class GameViewController: UIViewController {
    private let homeViewModel: HomeViewModel
    private var skView: SKView { view as! SKView }
    private let size = BackgroundNode.createBackgroundNode().size
    private lazy var gameState = GKStateMachine(
        states: [
            GameStateInitial(gameViewController: self),
            GameStateRunning(gameViewController: self),
            GameStateFinished(gameViewController: self),
            GameStatePaused(gameViewController: self)
        ]
    )

    private let soundEffectManager: SoundEffectManager

    // Initialize SoundEffectManager with preloaded sounds
    init(
        homeViewModel: HomeViewModel
    ) {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("AVAudioSession setup error: \(error)")
        }
        
        self.soundEffectManager = SoundEffectManager(
            scene: nil,
            soundFilesToPreload: [
                Assets.Sounds.wing,
                Assets.Sounds.gameOver,
                Assets.Sounds.point,
                Assets.Music.backgroundMusic
            ]
        )
        
        self.homeViewModel = homeViewModel
        
        super.init(nibName: nil, bundle: nil)
        soundEffectManager.preloadSounds()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = SKView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        //skView.showsPhysics = true
        //skView.showsFPS = true
        //skView.showsNodeCount = true
        gameState.enter(GameStateInitial.self)
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
    }
}


extension GameViewController {
    func openInitialGameScene() {
        let initialScene = GameInitialScene(
            size: size,
            gameState: gameState,
            soundEffectManager: soundEffectManager,
            viewModel: homeViewModel
        )
        soundEffectManager.setScene(initialScene)
        skView.presentScene(initialScene)
    }

    func openGameScene() {
        let gameScene = GameScene(
            size: size,
            gameState: gameState,
            soundEffectManager: soundEffectManager,
            viewModel: homeViewModel
        )
        soundEffectManager.setScene(gameScene)
        skView.presentScene(gameScene)
    }

    func openFinishedGameScene() {
        let finishedScene = GameFinishedScene(
            size: size,
            gameState: gameState,
            soundEffectManager: soundEffectManager,
            viewModel: homeViewModel
        )
        soundEffectManager.setScene(finishedScene)
        skView.presentScene(finishedScene)
    }
    
    func openPausedGameScene() {
        let pausedScene = GamePausedScene(
            size: size,
            gameState: gameState,
            soundEffectManager: soundEffectManager,
            viewModel: homeViewModel
        )
        soundEffectManager.setScene(pausedScene)
        skView.presentScene(pausedScene)
    }
}

extension GameViewController {
    var currentScene: SKScene? {
        return skView.scene
    }
}
