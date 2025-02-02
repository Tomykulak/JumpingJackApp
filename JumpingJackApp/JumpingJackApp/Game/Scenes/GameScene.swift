import SpriteKit
import SwiftUI
import GameplayKit
import AVFoundation


final class GameScene: SKScene {
    // data
    private let viewModel: HomeViewModel
    
    // Properties
    private var gameState: GKStateMachine
    private var player: PlayerNode!
    private var background: BackgroundNode!
    private var groundNode: GroundNode!
    private var topBoundaryNode: BoundaryNode!
    private var scoreLabel: ScoreNode!
    private var coinNode: CoinNode!
    private var notificationNode: NotificationNode!
    private var coinCountLabel: CoinCountLabel!
    private var pauseIcon: SKNode!
    private var resumeIcon: SKNode!
    
    // to delete the previous platforms
    private var groundNodes: [GroundNode] = []
    private var activeGroundNode: GroundNode?
    private var boundaryNodes: [BoundaryNode] = []
    private let fallingThresholdY: CGFloat = -100
    
    // to make platform start falling down
    private var lastPlatformTouchTime: TimeInterval?
    private let idleThreshold: TimeInterval = 2.0
    private var sceneCamera: SKCameraNode = SKCameraNode()
    private let platformFallingTreshold: Double = 30.0
    private let platformFallingText: String = "Platforms Fall Now!!!"
    private var didPlatformNotificationDisplay: Bool = false
    
    // properties for dynamic jump
    private var touchStartTime: TimeInterval?
    private var isBarActive: Bool = false
    private var isTouchValidForJump: Bool = false
    
    // sound
    private var soundEffectManager: SoundEffectManager
    
    // MARK: Init
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        initializeCamera()
        
        //      FOR DEBBUG
        //view.showsPhysics = true
        
        // MARK: Physics setup
        physicsWorld.contactDelegate = self
        
        //        TODO: ADJUST GRAVITY IN GAME
        //        physicsWorld.gravity = CGVector(
        //            dx: 0,
        //            dy: -5
        //        )
        
        // Initialize nodes
        // Initialize background and set its size
        background = BackgroundNode.createBackgroundNode()
        player = PlayerNode.createPlayerNode(for: viewModel.state.user)
        groundNode = GroundNode.createGroundNode()
        topBoundaryNode = BoundaryNode(width: size.width)
        scoreLabel = ScoreNode()
        coinCountLabel = CoinCountLabel()
        notificationNode = NotificationNode()
        pauseIcon = PauseIconNode.createPauseIcon()
        resumeIcon = PauseIconNode.createResumeIcon()
        // ADDED nodes on the scene
        
        camera?.addChild(background)
        addChild(groundNode)
        groundNodes.append(groundNode)
        addChild(player)
        addChild(topBoundaryNode)
        camera?.addChild(scoreLabel)
        camera?.addChild(coinCountLabel)
        camera?.addChild(notificationNode)
        camera?.addChild(pauseIcon)
        camera?.addChild(resumeIcon)
        pauseIcon.isHidden = false
        resumeIcon.isHidden = true

        groundNode.anchorPoint = .zero
        
        // MARK: Sounds setup
        groundNode.startMoving(bool: true)
        
        playerPosition()
        topNodePosition()
        positionScoreNode()
        positionOfCoinLabel()
        positionNotificationNode()
        positionPauseButton()
        
        soundEffectManager.playBackgroundMusic()
    }
    
    override func willMove(from view: SKView) {
        super.willMove(from: view)
        
        scaleMode = .aspectFill
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        // Position camera correctly
        camera?.position.x = player.position.x
        camera?.position.y = player.position.y
        
        // Make the platform fall after 2s of player touching it
        if let activeGroundNode = activeGroundNode {
            let state = gameState.currentState as? GameStateRunning
            if state?.score ?? 0 >= platformFallingTreshold {
                let didStartFalling = activeGroundNode.checkAndStartFalling(currentTime: currentTime)
                if didStartFalling {
                    // Clear active ground node if it starts falling
                    self.activeGroundNode = nil
                }
            }
        }
        // Make the player move with the platform
        player.updatePlayerPositionWithGroundMovement(activeGround: activeGroundNode)
        
        // Update jump bar if active
        player.handleJumpBar(touchesBegan: false, currentTime: currentTime)
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)

        switch gameState.currentState {
        case gameState.currentState as GameStateRunning:
            if nodesAtPoint.contains(where: { $0.name == "pauseIcon" }) {
                // Pause the game and mark the touch as invalid for jumping
                resumeIcon.isHidden = false
                pauseIcon.isHidden = true
                isTouchValidForJump = false
                gameState.enter(GameStatePaused.self)
                
            } else {
                // Mark the touch as valid and handle jump bar
                isTouchValidForJump = true
                player.handleJumpBar(touchesBegan: true, currentTime: CACurrentMediaTime())
            }
        case gameState.currentState as GameStatePaused:
            if nodesAtPoint.contains(where: { $0.name == "resumeIcon" }) {
                // Resume the game and prevent the next touchesEnded from triggering a jump
                resumeIcon.isHidden = true
                pauseIcon.isHidden = false
                gameState.enter(GameStateRunning.self)
                isTouchValidForJump = false
            }
        case gameState.currentState as GameStateFinished:
            gameState.enter(GameFinishedScene.self)
        default:
            break
        }
    }

    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)

        // Ensure the game is running and the touch was valid for a jump
        guard gameState.currentState is GameStateRunning, isTouchValidForJump else { return }

        let touchEndTime = CACurrentMediaTime()
        player.makeJump(holdDuration: touchEndTime - (player.holdStartTime ?? touchEndTime))
        player.handleJumpBar(touchesBegan: false)
    }
}
    
// MARK: SKPhysicsContactDelegate
extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard gameState.currentState is GameStateRunning else { return }

        // Determine the non-player body involved in the contact
        let noPlayerContactBody: SKPhysicsBody = contact.bodyA.node?.name == NodeName.player
            ? contact.bodyB
            : contact.bodyA
        
        // Display Notification of platforms falling
        if !didPlatformNotificationDisplay {
            let state = gameState.currentState as? GameStateRunning
            
            if state?.score ?? 0 >= platformFallingTreshold {
                didPlatformNotificationDisplay = true
                notificationNode.updateText(text: platformFallingText)

                notificationNode.run(
                    SKAction.sequence([
                        SKAction.wait(forDuration: 2.0),
                        SKAction.fadeOut(withDuration: 0.3)
                    ])
                )
            }
        }
        
        switch noPlayerContactBody.node?.name {
        case NodeName.ground:
            if let ground = noPlayerContactBody.node as? GroundNode,
               player.isTouchingGround(ground: ground) {
                player.setOnGround(true)
                increaseScore(node: noPlayerContactBody.node)
                activeGroundNode = ground
                ground.previousPosition = ground.position
                ground.setLastTouchTime(to: CACurrentMediaTime())
            }
        case NodeName.boundary:
            endGame()
        case NodeName.coin:
            coinNode.handleCoinCollision(coin: noPlayerContactBody.node as! CoinNode)
            increaseCoinCount(node: noPlayerContactBody.node)
        default:
            break
        }

        // Spawn next ground if the player is on a valid ground node
        if player.isTouchingGround(ground: groundNode) {
            groundNode = GroundNode.spawnNextGroundNodeWithBounds(
                groundNode: groundNode,
                scene: self.scene!,
                groundNodes: &groundNodes,
                boundaryNodes: &boundaryNodes
            )
            groundNode.startMoving(bool: true)
            // spawn coin logic
            if CoinNode.calculateProbabilityOfCoinAppearing() {
                coinNode = CoinNode.spawnCoinOnGroundNode(
                    groundNode: groundNode,
                    scene: self.scene!
                )
            }
            GroundNode.removeOldestGroundNode(groundNodes: &groundNodes)
            BoundaryNode.removeOldestBoundaryNode(boundaryNodes: &boundaryNodes)
        }
    }
}


// MARK: Public API
extension GameScene {
    
    func getPlayer() -> PlayerNode {
        return player
    }
}

private extension GameScene {
    
    func endGame() {
        //reset notification
        didPlatformNotificationDisplay = false
        // add coins to player
        addCoinsToPlayer()
        // check highest score and replace if its higher
        addHighestScoreToPlayer()
        
        gameState.enter(GameStateFinished.self)
        groundNodes.forEach { $0.removeAllActions() }
        boundaryNodes.forEach { $0.removeAllActions() }
    }
    
    func addCoinsToPlayer(){
        viewModel
            .send(
                .addCoins(
                    Int32(
                        (
                            gameState.currentState as? GameStateRunning
                        )?.coins ?? 0
                    )
                )
            )
    }
    
    func addHighestScoreToPlayer(){
        viewModel
            .send(
                .highestScore(
                    Int32(
                        (
                            gameState.currentState as? GameStateRunning
                        )?.score ?? 0
                    )
                )
            )
    }
    
    func increaseScore(node: SKNode?) {
        
        guard
            let state = gameState.currentState as? GameStateRunning
        else {
            return
        }
        
        // update the score
        state.updateScore(currentPlayerX: player.position.x)
        scoreLabel.updateText(score: state.score)
    }
    
    func increaseCoinCount(node: SKNode?) {
        guard
            let state = gameState.currentState as? GameStateRunning
        else { return }
        soundEffectManager.playSound(named: Assets.Sounds.point)
        
        state.updateCoinsCounter()
        coinCountLabel.updateCoinLabel(coinCount: state.coins)
    }
    
    func initializeCamera() {
        self.camera = sceneCamera
        addChild(sceneCamera)
        sceneCamera.xScale = 2
        sceneCamera.yScale = 2
    }
    // MARK: POSITIONS OF NODES ON GAME SCENE
    
    func positionScoreNode() {
        scoreLabel.position = CGPoint(
            x: size.width / 2 - 30,
            y: size.height / 2 - 80
        )
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.verticalAlignmentMode = .top
    }
    
    func positionOfCoinLabel() {
        coinCountLabel.position = CGPoint(
            x: scoreLabel.position.x,
            y: scoreLabel.position.y / 1.2
        )
        coinCountLabel.horizontalAlignmentMode = .right
        coinCountLabel.verticalAlignmentMode = .top
    }
    
    func positionNotificationNode() {
        notificationNode.position = CGPoint(
            x: 0,
            y: size.height / 2 - 130
        )
        notificationNode.horizontalAlignmentMode = .center
        notificationNode.verticalAlignmentMode = .top
    }

    func positionPauseButton() {
        let horizontalPadding: CGFloat = 50 // Distance from the right edge
        let verticalOffset: CGFloat = size.height / 2 - 50 // Current vertical positioning

        pauseIcon.position = CGPoint(
            x: size.width / 2 - horizontalPadding,
            y: verticalOffset
        )
        resumeIcon.position = CGPoint(
            x: size.width / 2 - horizontalPadding,
            y: verticalOffset
        )
    }

    
    func playerPosition() {
        player.position = CGPoint(
            x: size.width * 0.3,
            y: groundNode.size.height
        )
    }
    
    func topNodePosition() {
        topBoundaryNode.position = CGPoint(
            x: -groundNode.position.x + size.width,
            y: groundNode.position.y + size.height / 1.5
        )
    }
    
    func coinNodePosition() {
        guard let groundNode = groundNodes.first else { return }
        
        coinNode.position = CGPoint(
            x: groundNode.position.x + groundNode.size.width / 2,
            y: groundNode.position.y + groundNode.size.height + coinNode.size.height*1.5
        )
    }
}
