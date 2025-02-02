//
//  Assets.swift
//  JumpingJackApp
//
//  Created by Adam Smekal on 02.01.2025.
//

import SpriteKit

enum Assets {}

// MARK: Textures
extension Assets {
    enum Textures {
        static let background = "background"
        // platform for player to move on
        static let cobblePlatform = "cobble_platform"
        // element to block the player movement
        static let cobbleBlock = "cobble_block"
        // player texture
        static let jack = "jack"
        // skins
        static let jackIdle0 = "jackIdle0"
        static let jackIdle1 = "jackIdle1"
        static let jackIdle2 = "jackIdle2"
        
        static let getReady = "getReady"
        static let base = "base"
        static let coin = "coin"
    }
}

// MARK: Sounds
extension Assets {
    enum Sounds {
        static let hit = "hit.wav"
        static let point = "point.wav"
        static let wing = "wing.wav"
        static let gameOver = "gameOver.wav"
    }
}

extension Assets {
    enum Music {
        static let backgroundMusic = "gameMusic.wav"
        static let menuMusic = "menuMusic.wav"
    }
}

// MARK: Fonts
extension Assets {
    enum Fonts {
        static let flappy = "04b_19"
    }
}

// MARK: Buttons
extension Assets {
    enum Buttons {
        static let startButton = "playGameButton"
        static let againButton = "againGameButton"
        static let exitButton = "exitGameButton"
        static let resumeButton = "resumeGameButton"
    }
}
