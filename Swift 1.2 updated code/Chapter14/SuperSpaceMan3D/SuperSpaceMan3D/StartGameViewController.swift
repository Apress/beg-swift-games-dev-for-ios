//
//  StartGameViewController.swift
//  SuperSpaceMan3D
//
//  Created by Wesley Matlock on 12/14/14.
//  Copyright (c) 2014 Apress. All rights reserved.
//

import Foundation
import UIKit
import SceneKit
import SpriteKit

class StartGameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = SCNScene()
        scene.rootNode.addChildNode(createStartingText())
        
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 6, z: 30)
        
        let sceneView = self.view as! SCNView
        sceneView.backgroundColor = UIColor.blueColor()
        // allows the user to manipulate the camera
        sceneView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        sceneView.showsStatistics = true
        sceneView.scene = scene
        
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: "handleTap:")
        let gestureRecognizers = NSMutableArray()
        gestureRecognizers.addObject(tapGesture)
        if let existingGestureRecognizers = sceneView.gestureRecognizers {
            gestureRecognizers.addObjectsFromArray(existingGestureRecognizers)
        }
        sceneView.gestureRecognizers = gestureRecognizers as [AnyObject]
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        println("Segue called")
    }
    
    func handleTap(gestureRecognize: UIGestureRecognizer) {
        
        self.performSegueWithIdentifier("GameStart", sender: self)
    }
    
    func createStartingText() -> SCNNode {
        
        let startText = SCNText(string: "Start Game!", extrusionDepth: 1)
        startText.chamferRadius = 0.5
        startText.flatness = 0.1
        startText.font = UIFont(name: "Avenir-heavy", size: 8)
        startText.firstMaterial?.specular.contents = UIColor.blueColor()
        startText.firstMaterial?.reflective.contents = UIColor.redColor()
        startText.firstMaterial?.shininess = 0.4
        
        let startTextNode = SCNNode(geometry: startText)
        startTextNode.position = SCNVector3Make(-25, 0, 0)
        startTextNode.name = "StartingTextNode"
        
        return startTextNode
    }
    
    
}