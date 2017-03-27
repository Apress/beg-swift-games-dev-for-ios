//
//  GameView.swift
//  SuperSpaceMan3D
//
//  Created by Wesley Matlock on 10/25/14.
//  Copyright (c) 2014 Apress. All rights reserved.
//

import SceneKit

class GameView : SCNView {
  
  var touchCount:Int?
  
  
  override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
    var touchCount = event.allTouches()
    self.touchCount = touchCount?.count
  }
  
  override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
    self.touchCount = 0
  }
  
}
