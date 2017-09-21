//
//  GameScene.swift
//  BurningNut
//
//  Created by Tim Olbrich on 21.09.17.
//  Copyright © 2017 Tim Olbrich. All rights reserved.
//

import SpriteKit
import GameplayKit

struct PhysicsCategory {
    static let None      : UInt32 = 0
    static let All       : UInt32 = UInt32.max
    static let Sqirrel   : UInt32 = 0b1
    static let Bomb: UInt32 = 0b10
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let leftSquirrel = SKSpriteNode(imageNamed: "//leftSquirrel")
    let rightSquirrel = SKSpriteNode(imageNamed: "//rightSquirrel")
    let leftTree = SKSpriteNode(imageNamed: "//leftTree")
    let middleTree = SKSpriteNode(imageNamed: "//middleTree")
    let rightTree = SKSpriteNode(imageNamed: "//rightTree")

    override func didMove(to view: SKView) {
        
        self.addBomb()
        self.physicsWorld.gravity = CGVector.init(dx: 0.0, dy: -9.8)
    }
    
    func addBomb() {
        
        let bomb = SKSpriteNode(imageNamed: "bomb")
        bomb.position = CGPoint(x: -320, y: 0)
        bomb.size = CGSize(width: 15, height: 30)
        bomb.zPosition = 3
        
        bomb.physicsBody = SKPhysicsBody(rectangleOf: bomb.size)
        bomb.physicsBody?.categoryBitMask = PhysicsCategory.Bomb
        bomb.physicsBody?.contactTestBitMask = PhysicsCategory.Sqirrel
        bomb.physicsBody?.collisionBitMask = PhysicsCategory.None

        addChild(bomb)
        
        let moveBomb = SKAction.move(to: CGPoint(x: 320, y: 0), duration: 8)
        let rotateBomb = SKAction.rotate(byAngle: -20, duration: 8)
        let groupBomb = SKAction.group([moveBomb, rotateBomb])
        bomb.run(SKAction.repeatForever(groupBomb))
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
