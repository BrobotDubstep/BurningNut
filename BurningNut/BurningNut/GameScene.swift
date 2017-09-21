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
    
    let leftSquirrel = SKSpriteNode(imageNamed: "//leftSquirrel")
    let rightSquirrel = SKSpriteNode(imageNamed: "//rightSquirrel")
    let leftTree = SKSpriteNode(imageNamed: "//leftTree")
    let middleTree = SKSpriteNode(imageNamed: "//middleTree")
    let rightTree = SKSpriteNode(imageNamed: "//rightTree")

    override func didMove(to view: SKView) {
        
        self.addBomb()
        self.addBomb()
        self.addBomb()
    }
    
    func addBomb() {
        
        let bomb = SKSpriteNode(imageNamed: "bomb")
        //let actualY = random(min: bomb.size.height/2, max: size.height - bomb.size.height/2)
        bomb.position = CGPoint(x: -320, y: 0)
        bomb.size = CGSize(width: 15, height: 30)
        bomb.zPosition = 3

        addChild(bomb)
        
        //let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        
        let moveBomb = SKAction.move(to: CGPoint(x: 320, y: 0), duration: 8)
        let rotateBomb = SKAction.rotate(byAngle: -20, duration: 8)
        //let actionMoveDone = SKAction.removeFromParent()
        //bomb.run(SKAction.sequence([actionMove, actionMoveDone]))
        
        let groupBomb = SKAction.group([moveBomb, rotateBomb])
        bomb.run(SKAction.repeatForever(groupBomb))
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
