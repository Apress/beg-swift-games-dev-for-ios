import SpriteKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let backgroundNode : SKSpriteNode?
    let backgroundStarsNode  : SKSpriteNode?
    let backgroundPlanetNode : SKSpriteNode?
    let foregroundNode  : SKSpriteNode?
    var playerNode : SKSpriteNode?
    
    var impulseCount = 4
    let coreMotionManager = CMMotionManager()
    var xAxisAcceleration : CGFloat = 0.0
    
    let engineExhaust : SKEmitterNode?
    
    var score = 0
    let scoreTextNode = SKLabelNode(fontNamed: "Copperplate")
    let impulseTextNode = SKLabelNode(fontNamed: "Copperplate")
    
    let orbPopAction = SKAction.playSoundFileNamed("orb_pop.wav", waitForCompletion: false)
    
    let startGameTextNode = SKLabelNode(fontNamed: "Copperplate")
    
    let textureAtlas = SKTextureAtlas(named: "sprites.atlas")
    
    required init?(coder aDecoder: NSCoder) {
    
        super.init(coder: aDecoder)
    }
    
    override init(size: CGSize) {
    
        super.init(size: size)
        
        physicsWorld.contactDelegate = self
    
        physicsWorld.gravity = CGVectorMake(0.0, -5.0);
        
        backgroundColor = SKColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
    
        userInteractionEnabled = true
        
        // adding the background
        backgroundNode = SKSpriteNode(imageNamed: "Background")
        backgroundNode!.size.width = self.frame.size.width
        backgroundNode!.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        backgroundNode!.position = CGPoint(x: size.width / 2.0, y: 0.0)
        addChild(backgroundNode!)
        
        backgroundStarsNode = SKSpriteNode(imageNamed: "Stars")
        backgroundStarsNode!.size.width = self.frame.size.width
        backgroundStarsNode!.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        backgroundStarsNode!.position = CGPoint(x: size.width / 2.0, y: 0.0)
        addChild(backgroundStarsNode!)
        
        backgroundPlanetNode = SKSpriteNode(imageNamed: "PlanetStart")
        backgroundPlanetNode!.size.width = self.frame.size.width
        backgroundPlanetNode!.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        backgroundPlanetNode!.position = CGPoint(x: size.width / 2.0, y: 0.0)
        addChild(backgroundPlanetNode!)
        
        foregroundNode = SKSpriteNode()
        addChild(foregroundNode!)
        
        // add the player
        self.playerNode = SpaceMan(textureAtlas: self.textureAtlas)
        playerNode!.position = CGPoint(x: size.width / 2.0, y: 220.0)
        
        foregroundNode!.addChild(playerNode!)
        
        addBlackHolesToForeground()
        addOrbsToForeground()
        
        let engineExhaustPath = NSBundle.mainBundle().pathForResource("EngineExhaust", ofType: "sks")
        engineExhaust = NSKeyedUnarchiver.unarchiveObjectWithFile(engineExhaustPath!) as? SKEmitterNode;
        engineExhaust!.position = CGPointMake(0.0, -(playerNode!.size.height / 2));
        playerNode!.addChild(engineExhaust!)
        engineExhaust!.hidden = true;
        
        scoreTextNode.text = "SCORE : \(score)"
        scoreTextNode.fontSize = 20
        scoreTextNode.fontColor = SKColor.whiteColor()
        scoreTextNode.position =
            CGPointMake(size.width - 10, size.height - 20)
        scoreTextNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
        
        addChild(scoreTextNode)
        
        impulseTextNode.text = "IMPULSES : \(impulseCount)"
        impulseTextNode.fontSize = 20
        impulseTextNode.fontColor = SKColor.whiteColor()
        impulseTextNode.position = CGPointMake(10.0, size.height - 20)
        impulseTextNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        
        addChild(impulseTextNode)
        
        startGameTextNode = SKLabelNode(fontNamed: "Copperplate")
        startGameTextNode.text = "TAP ANYWHERE TO START!"
        startGameTextNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        startGameTextNode.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        startGameTextNode.fontSize = 20
        startGameTextNode.fontColor = SKColor.whiteColor()
        startGameTextNode.position =
            CGPoint(x: scene!.size.width / 2, y: scene!.size.height / 2)
        addChild(startGameTextNode)
    }
    
    func addOrbsToForeground() {
        
        let orbPlistPath =
            NSBundle.mainBundle().pathForResource("orbs", ofType: "plist")
        let orbDataDictionary : NSDictionary? =
            NSDictionary(contentsOfFile: orbPlistPath!)
        
        if let positionDictionary = orbDataDictionary {
            
            let positions = positionDictionary.objectForKey("positions") as NSArray
            
            for position in positions {
                
                let orbNode = Orb(textureAtlas: textureAtlas)
                let x = position.objectForKey("x") as CGFloat
                let y = position.objectForKey("y") as CGFloat
                orbNode.position = CGPointMake(x, y)
                foregroundNode!.addChild(orbNode)
            }
        }
    }
    
    func addBlackHolesToForeground() {
        
        let moveLeftAction = SKAction.moveToX(0.0, duration: 2.0)
        let moveRightAction = SKAction.moveToX(size.width, duration: 2.0)
        let actionSequence = SKAction.sequence([moveLeftAction, moveRightAction])
        let moveAction = SKAction.repeatActionForever(actionSequence)
        
        let blackHolePlistPath =
        NSBundle.mainBundle().pathForResource("blackholes", ofType: "plist")
        let blackHoleDataDictionary : NSDictionary? =
        NSDictionary(contentsOfFile: blackHolePlistPath!)
        
        if let positionDictionary = blackHoleDataDictionary {
            
            let positions = positionDictionary.objectForKey("positions") as NSArray
            
            for position in positions {
                
                let blackHoleNode = BlackHole(textureAtlas: textureAtlas)
                
                let x = position.objectForKey("x") as CGFloat
                let y = position.objectForKey("y") as CGFloat
                blackHoleNode.position = CGPointMake(x, y)
                
                blackHoleNode.runAction(moveAction)
                
                foregroundNode!.addChild(blackHoleNode)
            }
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        if !playerNode!.physicsBody!.dynamic {
            
            startGameTextNode.removeFromParent()
            
            playerNode!.physicsBody!.dynamic = true
            
            coreMotionManager.accelerometerUpdateInterval = 0.3
            coreMotionManager.startAccelerometerUpdatesToQueue(NSOperationQueue(),
                withHandler: {
                    
                    (data: CMAccelerometerData!, error: NSError!) in
                    
                    if let constVar = error {
                        
                        println("There was an error")
                    }
                    else {
                        
                        self.xAxisAcceleration = CGFloat(data!.acceleration.x)
                    }
            })
        }
        
        if impulseCount > 0 {
            
            playerNode!.physicsBody!.applyImpulse(CGVectorMake(0.0, 40.0))
            
            impulseCount--
            impulseTextNode.text = "IMPULSES : \(impulseCount)"
            
            engineExhaust!.hidden = false
            
            NSTimer.scheduledTimerWithTimeInterval(0.5, target: self,
                selector: "hideEngineExaust:", userInfo: nil, repeats: false)
        }
    }

    func didBeginContact(contact: SKPhysicsContact!) {
        
        var nodeB = contact!.bodyB!.node!
        
        if nodeB.name == "POWER_UP_ORB"  {
            
            self.runAction(orbPopAction)
            
            self.impulseCount++
            self.impulseTextNode.text = "IMPULSES : \(self.impulseCount)"
            
            self.score++
            self.scoreTextNode.text = "SCORE : \(self.score)"
            
            nodeB.removeFromParent()
        }
        else if nodeB.name == "BLACK_HOLE"  {
            
            playerNode!.physicsBody!.contactTestBitMask = 0
            impulseCount = 0
            
            var colorizeAction = SKAction.colorizeWithColor(UIColor.redColor(),
                colorBlendFactor: 1.0, duration: 1)
            playerNode!.runAction(colorizeAction)
        }
    }
    
    override func update(currentTime: NSTimeInterval) {
        
        if playerNode != nil {
            
            if playerNode!.position.y >= 180.0 &&
                playerNode!.position.y < 6400.0 {
                    
                backgroundNode!.position =
                    CGPoint(x: backgroundNode!.position.x,
                        y: -((playerNode!.position.y - 180.0)/8));
                    
                backgroundStarsNode!.position =
                    CGPointMake(backgroundStarsNode!.position.x,
                        -((playerNode!.position.y - 180.0)/6));
                    
                backgroundPlanetNode!.position =
                    CGPointMake(self.backgroundPlanetNode!.position.x,
                        -((playerNode!.position.y - 180.0)/8));
                
                foregroundNode!.position =
                    CGPointMake(foregroundNode!.position.x,
                        -(playerNode!.position.y - 180.0));
            }
            else if playerNode!.position.y > 7000.0 {
                
                gameOverWithResult(true)
            }
            else if playerNode!.position.y + playerNode!.size.height < 0.0 {
                
                gameOverWithResult(false)
            }
            
            removeOutOfSceneNodesWithName("BLACK_HOLE")
            removeOutOfSceneNodesWithName("POWER_UP_ORB")
        }
    }
    
    func removeOutOfSceneNodesWithName(name: String) {
        
        foregroundNode!.enumerateChildNodesWithName(name, usingBlock: {
            node, stop in
            
            if self.playerNode == nil {
                
                stop.memory = true
            }
            else if (self.playerNode!.position.y - node.position.y > self.size.height)
            {
                
                node!.removeFromParent()
            }
        })
    }
    
    func gameOverWithResult(gameResult: Bool) {
        
        playerNode!.removeFromParent()
        playerNode = nil
        
        let transition = SKTransition.crossFadeWithDuration(2.0)
        let menuScene = MenuScene(size: size,
            gameResult: gameResult,
            score: score)
        
        view?.presentScene(menuScene, transition: transition)
    }
    
    override func didSimulatePhysics() {
        
        if playerNode != nil {
            
            playerNode!.physicsBody!.velocity =
                CGVectorMake(xAxisAcceleration * 380.0,
                    playerNode!.physicsBody!.velocity.dy)
            
            if playerNode!.position.x < -(playerNode!.size.width / 2) {
                
                playerNode!.position = CGPoint(x: size.width - playerNode!.size.width / 2, y: playerNode!.position.y)
            }
            else if playerNode!.position.x > size.width {
                
                playerNode!.position =
                    CGPoint(x: playerNode!.size.width / 2,
                        y: playerNode!.position.y)
            }
        }
    }
    
    deinit {
        
        self.coreMotionManager.stopAccelerometerUpdates()
    }
    
    func hideEngineExaust(timer:NSTimer!) {
        
        if !engineExhaust!.hidden {
            
            engineExhaust!.hidden = true
        }
    }
}