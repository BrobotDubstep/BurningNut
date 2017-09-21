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
    
    let leftSquirrel = SKSpriteNode(imageNamed: "minisquirrelRight")
    let rightSquirrel = SKSpriteNode(imageNamed: "minisquirrel")
    let middleTree = SKSpriteNode(imageNamed: "tree-2")
    let leftTree = SKSpriteNode(imageNamed: "tree-1")
    let rightTree = SKSpriteNode(imageNamed: "tree-1")

    override func didMove(to view: SKView) {
        
        self.setupMatchfield()
        self.addBomb()
        
       
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
    
    func setupMatchfield() {
        
        leftSquirrel.position = CGPoint(x: -307.839, y: -89.305)
        leftSquirrel.size = CGSize(width: 51.321, height: 59.464)
        leftSquirrel.anchorPoint.x = 0.5
        leftSquirrel.anchorPoint.y = 0.5
        leftSquirrel.zPosition = 1
        addChild(leftSquirrel)
        
        rightSquirrel.position = CGPoint(x: 307.839, y: -89.305)
        rightSquirrel.size = CGSize(width: 51.321, height: 59.464)
        rightSquirrel.anchorPoint.x = 0.5
        rightSquirrel.anchorPoint.y = 0.5
        rightSquirrel.zPosition = 1
        addChild(rightSquirrel)
        
        middleTree.position = CGPoint(x: 0, y: -4.238)
        middleTree.size = CGSize(width: 124.354, height: 221.849)
        middleTree.anchorPoint.x = 0.5
        middleTree.anchorPoint.y = 0.5
        middleTree.zPosition = 1
        addChild(middleTree)
        
        leftTree.position = CGPoint(x: -147.94, y: -62.205)
        leftTree.size = CGSize(width: 119.261, height: 173.357)
        leftTree.anchorPoint.x = 0.5
        leftTree.anchorPoint.y = 0.5
        leftTree.zPosition = 1
        addChild(leftTree)
        
        rightTree.position = CGPoint(x: 147.94, y: -62.205)
        rightTree.size = CGSize(width: 119.261, height: 173.357)
        rightTree.anchorPoint.x = 0.5
        rightTree.anchorPoint.y = 0.5
        rightTree.zPosition = 1
        addChild(rightTree)
        
    }
}
