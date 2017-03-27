//
//  Obstacle.swift
//  SuperSpaceMan3D
//
//  Created by Wesley Matlock on 10/2/14.
//  Copyright (c) 2014 Apress. All rights reserved.
//

import SceneKit
class Obstacle {
  
  
  class func PyramidNode() -> SCNNode {
    
    let pyramid = SCNPyramid(width: 10.0, height: 20.0, length: 10.0)
    let pyramidNode = SCNNode(geometry: pyramid)
    pyramidNode.name = "pyramid"
    
    let position = SCNVector3Make(0, 0, -100)
    pyramidNode.position = position
    pyramidNode.geometry?.firstMaterial?.diffuse.contents = UIColor.blueColor()
    
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
    
    let globe = SCNSphere(radius: 15.0)
    let globeNode = SCNNode(geometry: globe)
    globeNode.name = "globe"

    globeNode.position = SCNVector3Make(20, 40, -50)
    globeNode.geometry?.firstMaterial?.diffuse.contents = UIColor.redColor()

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
    
    let box = SCNBox(width: 10, height: 10, length: 10, chamferRadius: 0)
    let boxNode = SCNNode(geometry: box)
    boxNode.name = "box"

    
    boxNode.geometry?.firstMaterial?.diffuse.contents = UIColor.brownColor()
    boxNode.position = SCNVector3Make(0, 10, -20)
    
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

    tubeNode.geometry?.firstMaterial?.diffuse.contents = UIColor.yellowColor()
    tubeNode.position = SCNVector3Make(-10, 0, -75)
    
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
    
    let cylinderNode = SCNNode(geometry:SCNCylinder(radius: 3, height: 12))
    cylinderNode.geometry?.firstMaterial?.diffuse.contents = UIColor.greenColor()
    cylinderNode.position = SCNVector3Make(14, 0, -25)
    cylinderNode.name = "cylinder"

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
    
    return torusNode
    
  }
  
}
