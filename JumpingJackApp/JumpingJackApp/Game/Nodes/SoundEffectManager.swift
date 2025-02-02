//
//  SoundEffects.swift
//  JumpingJackApp
//
//  Created by Tomáš Okruhlica on 08.01.2025.
//

import SpriteKit

class SoundEffectManager {
    private var soundActions: [String: SKAction] = [:]
    private let soundFilesToPreload: [String]
    private weak var scene: SKScene? // Scene where the sounds will be played

    // Initializer
    init(scene: SKScene?, soundFilesToPreload: [String]) {
        self.scene = scene
        self.soundFilesToPreload = soundFilesToPreload
    }

    // Preload sound actions
    func preloadSounds() {
        for soundName in soundFilesToPreload {
            if soundActions[soundName] == nil {
                let soundAction = SKAction.playSoundFileNamed(soundName, waitForCompletion: false)
                soundActions[soundName] = soundAction
            }
        }
    }

    // Play a preloaded sound
    func playSound(named soundName: String, waitForCompletion: Bool = false) {
        guard let scene = scene else { return }

        if let soundAction = soundActions[soundName] {
            scene.run(soundAction)
        } else {
            // Fallback: Dynamically create the action if not preloaded
            let fallbackAction = SKAction.playSoundFileNamed(soundName, waitForCompletion: waitForCompletion)
            scene.run(fallbackAction)
        }
    }
    
    func playBackgroundMusic(){
        let backgroundMusic: SKAudioNode
        guard let scene = scene else { return }
        
        if let musicURL = Bundle.main.url(forResource: Assets.Music.backgroundMusic, withExtension: nil) {
            backgroundMusic = SKAudioNode(url: musicURL)
            backgroundMusic.autoplayLooped = true
            scene.addChild(backgroundMusic) // Add it to the scene
        } else {
            print("Failed to load background music: \(Assets.Music.backgroundMusic)")
        }
    }

    // Update the scene for sound playback
    func setScene(_ scene: SKScene?) {
        self.scene = scene
    }
}
