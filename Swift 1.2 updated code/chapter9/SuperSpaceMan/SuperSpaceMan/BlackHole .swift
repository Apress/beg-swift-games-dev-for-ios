import Foundation
import SpriteKit

class BlackHole: SKSpriteNode {
    
    init(textureAtlas: SKTextureAtlas) {
        
        let frame0 = textureAtlas.textureNamed("BlackHole0")
        let frame1 = textureAtlas.textureNamed("BlackHole1")
        let frame2 = textureAtlas.textureNamed("BlackHole2")
        let frame3 = textureAtlas.textureNamed("BlackHole3")
        let frame4 = textureAtlas.textureNamed("BlackHole4")
        
        let blackHoleTextures = [frame0, frame1, frame2, frame3, frame4];
        let animateAction =
            SKAction.animateWithTextures(blackHoleTextures, timePerFrame: 0.2)
        
        let rotateAction = SKAction.repeatActionForever(animateAction)
        
        super.init(texture: frame0, color: UIColor.clearColor(), size: frame0.size())
        
        physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        physicsBody!.dynamic = false
        physicsBody!.categoryBitMask = CollisionCategoryBlackHoles
        physicsBody!.collisionBitMask = 0
        name = "BLACK_HOLE"
        
        runAction(rotateAction)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
