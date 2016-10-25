import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let backgroundNode : SKSpriteNode?
    var playerNode : SKSpriteNode?
    let orbNode : SKSpriteNode?
    
    let CollisionCategoryPlayer     : UInt32 = 0x1 << 1
    let CollisionCategoryPowerUpOrbs : UInt32 = 0x1 << 2

    required init?(coder aDecoder: NSCoder) {
    
        super.init(coder: aDecoder)
    }
    
    override init(size: CGSize) {
    
        super.init(size: size)
        
        physicsWorld.contactDelegate = self
    
        physicsWorld.gravity = CGVectorMake(0.0, -2.0);
        
        backgroundColor = SKColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
    
        userInteractionEnabled = true
        
        // adding the background
        backgroundNode = SKSpriteNode(imageNamed: "Background")
        backgroundNode!.size.width = self.frame.size.width
        backgroundNode!.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        backgroundNode!.position = CGPoint(x: size.width / 2.0, y: 0.0)
        addChild(backgroundNode!)
        
        // add the player
        playerNode = SKSpriteNode(imageNamed: "Player")
        
        playerNode!.physicsBody =
            SKPhysicsBody(circleOfRadius: playerNode!.size.width / 2)
        playerNode!.physicsBody!.dynamic = true
        
        playerNode!.position = CGPoint(x: size.width / 2.0, y: 80.0)
        playerNode!.physicsBody!.linearDamping = 1.0
        playerNode!.physicsBody!.allowsRotation = false
        playerNode!.physicsBody!.categoryBitMask = CollisionCategoryPlayer
        playerNode!.physicsBody!.contactTestBitMask = CollisionCategoryPowerUpOrbs
        playerNode!.physicsBody!.collisionBitMask = 0
        addChild(playerNode!)
        
        orbNode = SKSpriteNode(imageNamed: "PowerUp")
        orbNode!.position = CGPoint(x: 150.0, y: size.height - 25)
        orbNode!.physicsBody =
            SKPhysicsBody(circleOfRadius: orbNode!.size.width / 2)
        orbNode!.physicsBody!.dynamic = false
        orbNode!.physicsBody!.categoryBitMask = CollisionCategoryPowerUpOrbs
        orbNode!.physicsBody!.collisionBitMask = 0
        orbNode!.name = "POWER_UP_ORB"
        addChild(orbNode!)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        playerNode!.physicsBody!.applyImpulse(CGVectorMake(0.0, 40.0))
    }

    func didBeginContact(contact: SKPhysicsContact!) {
        
        var nodeB = contact.bodyB!.node!
        
        if nodeB.name == "POWER_UP_ORB" {
            
            nodeB.removeFromParent()
        }
    }
}
