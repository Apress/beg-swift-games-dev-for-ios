//
//  GameOverlay.swift
//  SuperSpaceMan3D
//
//  Created by Wesley Matlock on 12/7/14.
//  Copyright (c) 2014 Apress. All rights reserved.
//

import SpriteKit
import UIKit
import SceneKit

class GameOverlay: SKScene {
    
    var timeNode: SKLabelNode!
    var livesLeftNode: SKLabelNode!
    var lives:Int = 3
    var timerFormat: NSNumberFormatter!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
         anchorPoint = CGPointMake(0.5, 0.5)
         scaleMode = .ResizeFill
        
         timeNode = SKLabelNode(fontNamed: "AvenirNext-Bold")
         timeNode.text =  "Time: 0.0"
         timeNode.fontColor = SKColor.redColor()
         timeNode.horizontalAlignmentMode = .Left
         timeNode.verticalAlignmentMode = .Bottom
         timeNode.position = CGPointMake(-size.width/2 + 20, size.height/2 - 40)
         timeNode.name = "timer"
         addChild(timeNode)

         livesLeftNode = SKLabelNode(fontNamed: "AvenirNext-Bold")
         livesLeftNode.text = "Lives: \(lives)"
         livesLeftNode.fontColor = SKColor.redColor()
         livesLeftNode.horizontalAlignmentMode = .Right
         livesLeftNode.verticalAlignmentMode = .Bottom
         livesLeftNode.position = CGPointMake(size.width/2, size.height/2 - 40)
        
         timerFormat = NSNumberFormatter()
         timerFormat.numberStyle = .DecimalStyle
         timerFormat.minimumFractionDigits = 1
         timerFormat.maximumFractionDigits = 1

         addChild(livesLeftNode)
    }
    
    func startTimer() {
        var startTime = NSDate.timeIntervalSinceReferenceDate()
        var timerNode =  childNodeWithName("timer") as! SKLabelNode
        
        var timerAction = SKAction.runBlock({ () -> Void in
            var now = NSDate.timeIntervalSinceReferenceDate()
            var elapsedTime = NSTimeInterval( now - startTime )
            var tempString = String(format: "%@",  self.timerFormat.stringFromNumber(elapsedTime)!)
            timerNode.text = "Time: " + tempString
        })
        var startDelay = SKAction.waitForDuration(0.5)
        var timerDelay = SKAction.sequence([timerAction, startDelay])
        var timer = SKAction.repeatActionForever(timerDelay)
         timeNode.runAction(timer, withKey: "timerAction")
    }
    

    func updateLives(increase: Bool) {
        
        if increase {
             lives++
        }
        else {
             lives--
        }
         livesLeftNode.text = "Lives: \( lives)"
    }
}
