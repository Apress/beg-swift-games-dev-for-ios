//
//  Obstacle.swift
//  SuperSpaceMan3D
//
//  Created by Wesley Matlock on 10/2/14.
//  Copyright (c) 2014 Apress. All rights reserved.
//
import Foundation
import SceneKit

func randomSign() -> Float {
    if arc4random_uniform(2) == 0 {
        return 1.0
    }else {
        return -1.0
    }
}

func randomFloat() -> Float {
    return Float(arc4random_uniform(100))
}

func randomPosition() -> SCNVector3 {

    return SCNVector3Make(randomSign()*randomFloat(), randomSign()*randomFloat(), randomSign()*randomFloat())
}

class Obstacle {
    
    
    class func PyramidNode() -> SCNNode {
        
        let pyramid = SCNPyramid(width: 10.0, height: 20.0, length: 10.0)
        let pyramidNode = SCNNode(geometry: pyramid)
        pyramidNode.name = "pyramid"
        
        let position = SCNVector3Make(-100, 0, -40)
        pyramidNode.position = position
        pyramidNode.geometry?.firstMaterial?.diffuse.contents = UIColor.blueColor()
        pyramidNode.geometry?.firstMaterial?.specular.contents = UIColor.blueColor()
        pyramidNode.geometry?.firstMaterial?.shininess = 1.0
        
        pyramidNode.physicsBody = SCNPhysicsBody()
        pyramidNode.physicsBody?.type = .Dynamic
        pyramidNode.physicsBody?.categoryBitMask = ColliderType.Obstacle.rawValue
        pyramidNode.physicsBody?.collisionBitMask = ColliderType.all
        
        let rotation = CABasicAnimation(keyPath: "rotation")
        
        // Spin around the Y-Axis
        rotation.fromValue = NSValue(SCNVector4:SCNVector4Make(0, 0, 0, 0))
        rotation.toValue =  NSValue(SCNVector4:SCNVector4Make(0, 1, 0, Float(2.0*M_PI)))
        rotation.duration = 5
        rotation.repeatCount = .infinity
        pyramidNode.addAnimation(rotation, forKey: "rotation")

        return pyramidNode
        
    }
    
    class func GlobeNode() -> SCNNode {
        
        let globe = SCNSphere(radius: 30.0)
        let globeNode = SCNNode(geometry: globe)
        globeNode.name = "globe"
        globeNode.position = SCNVector3Make(100, 30, -50)
        
        globeNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "earthDiffuse")
        globeNode.geometry?.firstMaterial?.ambient.contents = UIImage(named: "earthAmbient")
        globeNode.geometry?.firstMaterial?.specular.contents = UIImage(named: "earthSpecular")
        globeNode.geometry?.firstMaterial?.normal.contents = UIImage(named: "earthNormal")
        globeNode.geometry?.firstMaterial?.diffuse.mipFilter = SCNFilterMode.Linear

        
        globeNode.physicsBody = SCNPhysicsBody()
        globeNode.physicsBody?.type = .Dynamic
        globeNode.physicsBody?.categoryBitMask = ColliderType.Obstacle.rawValue
        globeNode.physicsBody?.collisionBitMask = ColliderType.all
        
        let rotation = CABasicAnimation(keyPath: "rotation")
        
        // Spin around the Y-Axis
        rotation.fromValue = NSValue(SCNVector4:SCNVector4Make(0, 0, 0, 0))
        rotation.toValue =  NSValue(SCNVector4:SCNVector4Make(0, 1, 0, Float(2.0*M_PI)))
        rotation.duration = 10
        rotation.repeatCount = .infinity
        globeNode.addAnimation(rotation, forKey: "rotation")
        
        let moveGlobeUp = SCNAction.moveByX(0.0, y: 10.0, z: 0.0, duration: 1.0)
        let moveGlobeDown = SCNAction.moveByX(0.0, y: -10.0, z: 0.0, duration: 1.0)
        let sequence = SCNAction.sequence([moveGlobeUp, moveGlobeDown])
        let repeateSequence = SCNAction.repeatActionForever(sequence)
        globeNode.runAction(repeateSequence)
        
        return globeNode
    }
    
    
    class func BoxNode() -> SCNNode {
        
        let box = SCNBox(width: 20, height: 10, length: 40, chamferRadius: 0)
        let boxNode = SCNNode(geometry: box)
        boxNode.name = "box"
        
        var materials = [SCNMaterial]()
        let boxImage = "boxSide"
        for i in 1...6 {
            let material = SCNMaterial()
            material.diffuse.contents = UIImage(named: boxImage + String(i))
            materials.append(material)
        }

        boxNode.geometry?.materials = materials
        boxNode.position = SCNVector3Make(0, 10, -20)

        boxNode.physicsBody = SCNPhysicsBody()
        boxNode.physicsBody?.type = .Dynamic
        boxNode.physicsBody?.categoryBitMask = ColliderType.Obstacle.rawValue
        boxNode.physicsBody?.collisionBitMask = ColliderType.all
        
        // Spin around the z-Axis
        let rotation = CABasicAnimation(keyPath: "rotation")

        rotation.fromValue = NSValue(SCNVector4:SCNVector4Make(0, 0, 0, 0))
        rotation.toValue =  NSValue(SCNVector4:SCNVector4Make(0, 0, 1, Float(2.0*M_PI)))
        rotation.duration = 10
        rotation.repeatCount = .infinity
        boxNode.addAnimation(rotation, forKey: "rotation")
        
        return boxNode
    }
    
    class func TubeNode() -> SCNNode {
    
        let tube = SCNTube(innerRadius: 10, outerRadius: 14, height: 20)
        let tubeNode = SCNNode(geometry: tube)
        tubeNode.name = "tube"
        tubeNode.position = SCNVector3Make(-50, 20, 10)
        
        tubeNode.geometry?.firstMaterial?.diffuse.contents = UIColor.redColor()
        
        tubeNode.physicsBody = SCNPhysicsBody(type: .Dynamic, shape: nil)
//        tubeNode.physicsBody?.type = .Dynamic
        tubeNode.physicsBody?.categoryBitMask = ColliderType.Obstacle.rawValue
        tubeNode.physicsBody?.collisionBitMask = ColliderType.all

        let rotation = CABasicAnimation(keyPath: "rotation")
        // Spin around the Z-Axis
        rotation.fromValue = NSValue(SCNVector4:SCNVector4Make(0, 0, 0, 0))
        rotation.toValue =  NSValue(SCNVector4:SCNVector4Make(0, 0, 1, Float(2.0*M_PI)))
        rotation.duration = 5
        rotation.repeatCount = .infinity
        tubeNode.addAnimation(rotation, forKey: "rotation")
        
        return tubeNode
    }
    
    class func CylinderNode() -> SCNNode {
        
        let cylinderNode = SCNNode(geometry:SCNCylinder(radius: 25, height: 70))
        cylinderNode.position = SCNVector3Make(0, 35, -10)
        cylinderNode.name = "cylinder"
        
        cylinderNode.physicsBody = SCNPhysicsBody()
        cylinderNode.physicsBody?.type = .Dynamic
        cylinderNode.physicsBody?.categoryBitMask = ColliderType.Obstacle.rawValue
        cylinderNode.physicsBody?.collisionBitMask = ColliderType.all
        
        cylinderNode.geometry?.firstMaterial?.diffuse.contents = UIColor.yellowColor()
        cylinderNode.geometry?.firstMaterial?.specular.contents = UIColor.yellowColor()
        cylinderNode.geometry?.firstMaterial?.shininess = 0.5
        
        let scaleToZero = SCNAction.scaleTo(0.0, duration: 0)
        let scaleUp = SCNAction.scaleTo(1.0, duration: 5)
        let opacityToZero = SCNAction.fadeOutWithDuration(5)
        
        let sequence = SCNAction.sequence([scaleToZero, scaleUp])
        let repeateSequence = SCNAction.repeatAction(sequence, count: 10)
        cylinderNode.runAction(repeateSequence)
        
        return cylinderNode        
    }
    
    class func TorusNode() -> SCNNode {
        
        let torus = SCNTorus(ringRadius: 12, pipeRadius: 5)
        let torusNode = SCNNode(geometry: torus)
        torusNode.name = "torus"
        
        torusNode.position = SCNVector3Make(-30, 7, 60)
        
        torusNode.geometry?.firstMaterial?.diffuse.contents = UIColor.greenColor()
        torusNode.geometry?.firstMaterial?.shininess = 0.75
        
        torusNode.physicsBody = SCNPhysicsBody()
        torusNode.physicsBody?.type = .Dynamic
        torusNode.physicsBody?.categoryBitMask = ColliderType.Obstacle.rawValue
        torusNode.physicsBody?.collisionBitMask = ColliderType.all
        
        return torusNode
    }
    
}
