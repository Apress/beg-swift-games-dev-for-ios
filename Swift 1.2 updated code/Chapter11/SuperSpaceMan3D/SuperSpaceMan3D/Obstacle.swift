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
    
    let position = SCNVector3Make(0, 0, -100)
    pyramidNode.position = position
    pyramidNode.geometry?.firstMaterial?.diffuse.contents = UIColor.blueColor()
    
    return pyramidNode
    }
    
    class func GlobeNode() -> SCNNode {
    
    let globe = SCNSphere(radius: 15.0)
    let globeNode = SCNNode(geometry: globe)
    globeNode.position = SCNVector3Make(20, 40, -50)
    globeNode.geometry?.firstMaterial?.diffuse.contents = UIColor.redColor()
    
    return globeNode
    }
    
    
    class func BoxNode() -> SCNNode {
    
    let box = SCNBox(width: 10, height: 10, length: 10, chamferRadius: 0)
    let boxNode = SCNNode(geometry: box)
    
    boxNode.geometry?.firstMaterial?.diffuse.contents = UIColor.brownColor()
    boxNode.position = SCNVector3Make(0, 10, -20)
    
    return boxNode
    
    }
    
    class func TubeNode() -> SCNNode {
    
    let tube = SCNTube(innerRadius: 10, outerRadius: 14, height: 20)
    let tubeNode = SCNNode(geometry: tube)
    
    tubeNode.geometry?.firstMaterial?.diffuse.contents = UIColor.yellowColor()
    tubeNode.position = SCNVector3Make(-10, 0, -75)
    
    return tubeNode
    }
    
    
    class func CylinderNode() -> SCNNode {
    
    let cylinderNode = SCNNode(geometry:SCNCylinder(radius: 3, height: 12))
    cylinderNode.geometry?.firstMaterial?.diffuse.contents = UIColor.greenColor()
    cylinderNode.position = SCNVector3Make(14, 0, -25)
    
    return cylinderNode
    
    }
    
    class func TorusNode() -> SCNNode {
    
    let torus = SCNTorus(ringRadius: 12, pipeRadius: 5)
    let torusNode = SCNNode(geometry: torus)
    
    torusNode.geometry?.firstMaterial?.diffuse.contents = UIColor.orangeColor()
    torusNode.position = SCNVector3Make(50, 10, -50)
    
    return torusNode
    
    }
    
}
