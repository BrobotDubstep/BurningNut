//
//  GameScene.swift
//  BurningNut
//
//  Created by Tim Olbrich on 21.09.17.
//  Copyright © 2017 Tim Olbrich. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var bomb : SKShapeNode?
    
    override func didMove(to view: SKView) {
        
        self.bomb = self.childNode(withName: "//bomb") as? SKShapeNode
        
        if let bomb = self.bomb {

        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
