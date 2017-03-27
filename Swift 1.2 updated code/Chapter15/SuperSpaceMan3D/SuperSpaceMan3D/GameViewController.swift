//
//  GameViewController.swift
//  SuperSpaceMan3D
//
//  Copyright (c) 2014 Apress. All rights reserved.
//

import SceneKit
import CoreMotion
import UIKit
import Foundation

//let CollisionCategorySpaceman      : UInt32 = 0x1 << 1
//let CollisionCategoryEnemy         : UInt32 = 0x1 << 2
//let CollisionCategoryObstacle      : UInt32 = 0x1 << 3
//let CollisionCategoryWall          : UInt32 = 0x1 << 4



enum ColliderType: Int {
    case Spaceman = 1
    case Enemy = 2
    case Obstacle = 4
    case Wall = 8
    
    static var all = ColliderType.Spaceman.rawValue |
        ColliderType.Enemy.rawValue |
        ColliderType.Obstacle.rawValue |
        ColliderType.Wall.rawValue
}

class GameViewController: UIViewController, SCNSceneRendererDelegate, SCNPhysicsContactDelegate {
    var spotLight: SCNNode!
    var cameraNode: SCNNode!
    var spaceManNode: SCNNode!
    var enemyNode: SCNNode!
    var startTextNode: SCNNode!
    var endTextNode: SCNNode!
    
    //acceleraometer
    var motionManager: CMMotionManager!
    var accelerometer: UIAccelerationValue!
    var orientation: CGFloat!
    
    // Movement
    var spacemanPhysicsBehavior:SCNPhysicsBehavior!
    var spacemanTurn:CGFloat!
    var vehicleSteering:CGFloat!
    let spacemanSpeed = 50

    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create the scene
        let scene = createMainScene()
        
        scene.physicsWorld.gravity = SCNVector3Make(0, 0, 0)
        
        
        // Get the games main view
        let sceneView =  view as! SCNView
        
        sceneView.scene = scene
        
        setupAccelerometer()
        
        // Optional, but nice to be turned on during developement
        sceneView.showsStatistics = true
        
        // Camera manipulation by the user
        //        sceneView.allowsCameraControl = true
        sceneView.pointOfView = cameraNode
        
        sceneView.overlaySKScene = GameOverlay(size:  view.frame.size)
        
        sceneView.delegate = self
        sceneView.scene!.physicsWorld.speed = 5.0
        sceneView.scene!.physicsWorld.contactDelegate = self

    }
    
    func createMainScene() -> SCNScene {
        var mainScene = SCNScene()
        
        setupLighting(mainScene)
        setupFloor(mainScene)
        setupWalls(mainScene)
        
        spaceManNode = setupSpaceMan(mainScene)
        spaceManNode!.physicsBody = SCNPhysicsBody(type: .Dynamic, shape: nil)
        spaceManNode!.physicsBody!.categoryBitMask = ColliderType.Spaceman.rawValue
        spaceManNode!.physicsBody!.collisionBitMask = ColliderType.Enemy.rawValue | ColliderType.Obstacle.rawValue
        spaceManNode.physicsBody!.mass = 1
        
//        spaceManNode!.physicsBody!.categoryBitMask = CollisionCategorySpaceman
//        spaceManNode!.physicsBody!.collisionBitMask = CollisionCategoryObstacle | CollisionCategoryEnemy

        
        enemyNode =  setupEnemy(mainScene)
        enemyNode!.physicsBody = SCNPhysicsBody(type: .Dynamic, shape: nil)
        enemyNode!.physicsBody!.categoryBitMask = ColliderType.Enemy.rawValue
        enemyNode!.physicsBody!.collisionBitMask = ColliderType.Spaceman.rawValue
        enemyNode.physicsBody?.mass = 1
        
        setupCameras(mainScene)
        setupObstacles(mainScene)
        
        return mainScene
    }
    
    func setupLighting(scene:SCNScene) {
        
        var ambientLight = SCNNode()
        ambientLight.light = SCNLight()
        ambientLight.light!.type = SCNLightTypeAmbient
        ambientLight.light!.color = UIColor(white: 0.3, alpha: 1.0)
        scene.rootNode.addChildNode(ambientLight)
        
        var lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = SCNLightTypeSpot
        lightNode.light!.castsShadow = true
        lightNode.light!.color = UIColor(white: 0.8, alpha: 1.0)
        lightNode.position = SCNVector3Make(0, 80, 30)
        lightNode.rotation = SCNVector4Make(1, 0, 0, Float(-M_PI/2.8))
        lightNode.light!.spotInnerAngle = 0
        lightNode.light!.spotOuterAngle = 50
        lightNode.light!.shadowColor = UIColor.blackColor()
        lightNode.light!.zFar = 500
        lightNode.light!.zNear = 50
        scene.rootNode.addChildNode(lightNode)
        
        //Save for later
        spotLight = lightNode
    }
    
    func setupFloor(scene:SCNScene) {
        //Flooring
        var floor = SCNFloor()
        floor.reflectionFalloffEnd = 10
        var floorNode = SCNNode(geometry: floor)
        floorNode.name = "Floor"
        floorNode.geometry?.firstMaterial?.diffuse.contents = "Floor"
        floorNode.geometry?.firstMaterial?.diffuse.contentsTransform = SCNMatrix4MakeScale(2, 2, 1)
        floorNode.geometry?.firstMaterial?.locksAmbientWithDiffuse = true
            
        var staticBody = SCNPhysicsBody()
        staticBody.type = SCNPhysicsBodyType.Static
        floorNode.physicsBody = staticBody
        scene.rootNode.addChildNode(floorNode)
        
    }
    
    func setupWalls(scene:SCNScene) {
        
        // WALLS!
        var wall = SCNNode(geometry: SCNBox(width: 800, height: 400, length: 4, chamferRadius: 0))
        wall.geometry!.firstMaterial!.diffuse.contents = "Wall"
        wall.geometry!.firstMaterial!.diffuse.contentsTransform = SCNMatrix4Mult(SCNMatrix4MakeScale(24, 2, 1), SCNMatrix4MakeTranslation(0, 1, 0))
        wall.geometry!.firstMaterial!.diffuse.wrapS = SCNWrapMode.Repeat
        wall.geometry!.firstMaterial!.diffuse.wrapT = SCNWrapMode.Mirror
        wall.geometry!.firstMaterial!.doubleSided = false
        wall.geometry!.firstMaterial!.locksAmbientWithDiffuse = true
        wall.castsShadow = false
        wall.position = SCNVector3Make(0, 50, -92)
        wall.physicsBody = SCNPhysicsBody()
        wall.physicsBody!.type = .Static
        wall.physicsBody!.categoryBitMask = ColliderType.Wall.rawValue
        wall.physicsBody!.collisionBitMask = ColliderType.all
        
        scene.rootNode.addChildNode(wall)
        
        //Wall2
        wall = wall.clone() as! SCNNode
        wall.position = SCNVector3Make(-202, 50, 0)
        wall.rotation = SCNVector4Make(0, 1, 0, Float(M_PI_2))
        wall.physicsBody = SCNPhysicsBody()
        wall.physicsBody!.type = .Static
        wall.physicsBody!.categoryBitMask = ColliderType.Wall.rawValue
        wall.physicsBody!.collisionBitMask = ColliderType.all
        
        scene.rootNode.addChildNode(wall)
        
        //Wall3
        wall = wall.clone() as! SCNNode
        wall.position = SCNVector3Make(202, 50, 0)
        wall.rotation = SCNVector4Make(0, 1, 0, Float(-M_PI_2))
        wall.physicsBody = SCNPhysicsBody()
        wall.physicsBody!.type = .Static
        wall.physicsBody!.categoryBitMask = ColliderType.Wall.rawValue
        wall.physicsBody!.collisionBitMask = ColliderType.all
        
        scene.rootNode.addChildNode(wall)
        
        //backwall
        var backWall = SCNNode(geometry: SCNPlane(width: 800, height: 400))
        backWall.geometry!.firstMaterial = wall.geometry!.firstMaterial
        backWall.position = SCNVector3Make(0, 50, 200)
        backWall.rotation = SCNVector4Make(1, 0, 0, Float(M_PI))
        backWall.castsShadow = false
        backWall.physicsBody = SCNPhysicsBody()
        backWall.physicsBody!.type = .Static
        wall.physicsBody!.categoryBitMask = ColliderType.Wall.rawValue
        wall.physicsBody!.collisionBitMask = ColliderType.all
        
        scene.rootNode.addChildNode(backWall)
        
        var ceilNode = SCNNode(geometry: SCNPlane(width: 800, height: 400))
        ceilNode.position = SCNVector3Make(0, 100, 0)
        ceilNode.rotation = SCNVector4Make(1, 0, 0, Float(M_PI_2))
        ceilNode.geometry!.firstMaterial!.doubleSided = false
        ceilNode.geometry!.firstMaterial!.locksAmbientWithDiffuse = true
        ceilNode.castsShadow = false
        wall.physicsBody!.categoryBitMask = ColliderType.Wall.rawValue
        wall.physicsBody!.collisionBitMask = ColliderType.all
        
        scene.rootNode.addChildNode(ceilNode)
    }
    
    func setupSpaceMan(scene:SCNScene) -> SCNNode {
        
        var spaceManScene = SCNScene(named: "art.scnassets/Hero.dae")
        var spaceManNode = spaceManScene!.rootNode.childNodeWithName("hero", recursively: false)
        spaceManNode!.name = "hero"
        spaceManNode!.position = SCNVector3Make(0, 0, 200)
        spaceManNode!.rotation = SCNVector4Make(0, 1, 0, Float(M_PI))
        scene.rootNode.addChildNode(spaceManNode!)
        
        return spaceManNode!
    }
    
    func setupEnemy(scene:SCNScene) -> SCNNode {
        
        var enemyScene = SCNScene(named: "art.scnassets/Enemy.dae")
        var enemyNode = enemyScene!.rootNode.childNodeWithName("enemy", recursively: false)
        enemyNode!.name = "enemy"
        enemyNode!.position = SCNVector3Make(40, 10, 30)
        enemyNode!.rotation = SCNVector4Make(0, 1, 0, Float(M_PI))
        scene.rootNode.addChildNode(enemyNode!)
        
        return enemyNode!
    }
    
    func setupObstacles(scene:SCNScene) {
        
        scene.rootNode.addChildNode(Obstacle.PyramidNode())
        scene.rootNode.addChildNode(Obstacle.GlobeNode())
        scene.rootNode.addChildNode(Obstacle.BoxNode())
        scene.rootNode.addChildNode(Obstacle.CylinderNode())
        scene.rootNode.addChildNode(Obstacle.TorusNode())
        scene.rootNode.addChildNode(Obstacle.TubeNode())
    }
    
    func setupCameras(scene:SCNScene) {
        
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.camera!.zFar = 500
        cameraNode.position = SCNVector3Make(0, 30, 200)
        cameraNode.rotation  = SCNVector4Make(1, 0, 0, Float(-M_PI_4*0.75))
        scene.rootNode.addChildNode(cameraNode)
        
        var spaceManCameraNode = SCNNode()
        spaceManCameraNode.camera = SCNCamera()
        spaceManCameraNode.camera!.xFov = 75
        spaceManCameraNode.camera!.zFar = 500
        spaceManCameraNode.position = SCNVector3Make(0, 3.5, 2.5)
        spaceManCameraNode.rotation = SCNVector4Make(0, 1, 0, Float(M_PI))
        
        //need to add this camera to the spaceman
        spaceManNode.addChildNode(spaceManCameraNode)
    }
    
    
    func setupAccelerometer() {
        
        motionManager = CMMotionManager()
        if  motionManager.accelerometerAvailable {
            
            motionManager.accelerometerUpdateInterval = 1/60.0
            motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue()) {
                (data, error) in
                
                let currentX =  self.spaceManNode.position.x
                let currentY =  self.spaceManNode.position.y
                let currentZ =  self.spaceManNode.position.z
                
                // Moving right?
                if data.acceleration.y < -0.20 {
                    
                    var destinationX = (Float(data.acceleration.y) * Float( self.spacemanSpeed) + Float(currentX))
                    var destinationY = Float(currentY)
                    var destinationZ = Float(currentZ)
                    
                    self.motionManager.accelerometerActive == true
                    let action = SCNAction.moveTo(SCNVector3Make(destinationX, destinationY, destinationZ), duration: 1)
                    self.spaceManNode.runAction(action)
                    
                }
                else if data.acceleration.y > 0.20 {
                    var destinationX = (Float(data.acceleration.y) * Float(self.spacemanSpeed) + Float(currentX))
                    var destinationY = Float(currentY)
                    var destinationZ = Float(currentZ)
                    
                    self.motionManager.accelerometerActive == true
                    let action = SCNAction.moveTo(SCNVector3Make(destinationX, destinationY, destinationZ), duration: 1)
                    self.spaceManNode.runAction(action)
                    
                }
            }
        }
    }
    
    //MARK - Animate the enemy
    
    
    
    //MARK - SCNSceneRendererDelegate Function
    func renderer(aRenderer: SCNSceneRenderer, didSimulatePhysicsAtTime time: NSTimeInterval) {
        
        let gameView =  view as! GameView
        let moveDistance = Float(10.0)
        let moveSpeed = NSTimeInterval(1.0)
        
        let currentX =  spaceManNode.position.x
        let currentY =  spaceManNode.position.y
        let currentZ =  spaceManNode.position.z
        
        if gameView.touchCount == 1 {
//            spaceManNode.physicsBody?.applyForce(SCNVector3Make(currentX, currentY, currentZ - moveDistance), impulse: true);
            let action = SCNAction.moveTo(SCNVector3Make(currentX, currentY, currentZ - moveDistance), duration: moveSpeed);
            spaceManNode.runAction(action)
            
        }
        else if gameView.touchCount == 2 {
            let action = SCNAction.moveTo(SCNVector3Make(currentX, currentY, currentZ + moveDistance), duration: moveSpeed)
            spaceManNode.runAction(action)
        }
        else if gameView.touchCount == 4 {
            let action = SCNAction.moveTo(SCNVector3Make(0, 0, 0), duration: moveSpeed)
            spaceManNode.runAction(action)
        }
        
        //follow the camera
        let spaceman =  spaceManNode.presentationNode()
        var spacemanPosition = spaceman.position
        let cameraDamping:Float = 0.3
        
        var targetPosition =  SCNVector3Make(spacemanPosition.x, 30.0, spacemanPosition.z + 20.0)
        var cameraPosition =  cameraNode.position
        cameraPosition = SCNVector3Make(cameraPosition.x * (1.0 - cameraDamping) + targetPosition.x * cameraDamping,
            cameraPosition.y * (1.0 - cameraDamping) + targetPosition.y * cameraDamping,
            cameraPosition.z * (1.0 - cameraDamping) + targetPosition.z * cameraDamping);
        
        cameraNode.position = cameraPosition
        spotLight.position = SCNVector3Make(spacemanPosition.x, 90, spacemanPosition.z + 40.0)
        spotLight.rotation = SCNVector4Make(1, 0, 0, Float(-M_PI/2.8))
    }
    
    //MARK: Contact delegate
    func physicsWorld(world: SCNPhysicsWorld, didBeginContact contact: SCNPhysicsContact) {
        println("Started contact")
        
        var collisionDetaction = contact.nodeA.categoryBitMask | contact.nodeB.categoryBitMask
        
        if collisionDetaction ==  ColliderType.all {
            
            println("touched something--------")
        }
    }
    
    func physicsWorld(world: SCNPhysicsWorld, didEndContact contact: SCNPhysicsContact) {
        println("Physics ---  END-----!!")
    }
    
    func physicsWorld(world: SCNPhysicsWorld, didUpdateContact contact: SCNPhysicsContact) {
        println("Physics ---  update!!")
    }
}



