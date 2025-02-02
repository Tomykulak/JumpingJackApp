import SpriteKit

final class BackgroundNode: SKSpriteNode {
    
    // MARK: - Initializer
    init(texture: SKTexture) {
        super.init(
            texture: texture,
            color: .clear,
            size: texture.size()
        )
        setupBackgroundNode()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Static Factory Method
    static func createBackgroundNode() -> BackgroundNode {
        let texture = loadBackgroundTexture()
        return BackgroundNode(texture: texture)
    }

    // MARK: - Setup Functions
    private static func loadBackgroundTexture() -> SKTexture {
        return SKTexture(imageNamed: Assets.Textures.background)
    }

    private func setupBackgroundNode() {
        zPosition = Layer.background
        name = NodeName.background
    }
}
