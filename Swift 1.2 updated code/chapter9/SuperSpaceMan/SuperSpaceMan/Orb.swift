import Foundation
import SpriteKit

class Orb: SKSpriteNode {
    
    init(textureAtlas: SKTextureAtlas) {
        
        let texture = textureAtlas.textureNamed("PowerUp")
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        
        physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        physicsBody!.dynamic = false
        
        physicsBody!.categoryBitMask = CollisionCategoryPowerUpOrbs
        physicsBody!.collisionBitMask = 0
        name = "POWER_UP_ORB"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}