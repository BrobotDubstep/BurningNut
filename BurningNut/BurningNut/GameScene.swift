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
    static let Squirrel   : UInt32 = 0b1
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
        
        self.physicsWorld.gravity = CGVector.init(dx: 0.0, dy: -6)
        physicsWorld.contactDelegate = self
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }

        if ((firstBody.categoryBitMask & PhysicsCategory.Squirrel != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Bomb != 0)) {
            if let monster = firstBody.node as? SKSpriteNode, let
                projectile = secondBody.node as? SKSpriteNode {
                projectileDidCollideWithMonster(bomb: projectile, squirrel: monster)
            }
        }
    }
    
    func projectileDidCollideWithMonster(bomb: SKSpriteNode, squirrel: SKSpriteNode) {
        
        let explosion = SKSpriteNode(imageNamed: "explosion")
        explosion.position = bomb.position
        explosion.size = CGSize(width: 40, height: 40)
        explosion.zPosition = 1
        addChild(explosion)
        run(SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: true))
        bomb.removeFromParent()
        squirrel.removeFromParent()
    }
    
    func addBomb() {
        
        let bomb = SKSpriteNode(imageNamed: "bomb")
        bomb.position = CGPoint(x: leftSquirrel.position.x, y: 0)
        bomb.size = CGSize(width: 15, height: 30)
        bomb.zPosition = 1
        
        bomb.physicsBody = SKPhysicsBody(rectangleOf: bomb.size)
        rightSquirrel.physicsBody?.isDynamic = false
        bomb.physicsBody?.categoryBitMask = PhysicsCategory.Bomb
        bomb.physicsBody?.contactTestBitMask = PhysicsCategory.Squirrel
        bomb.physicsBody?.collisionBitMask = PhysicsCategory.None

        addChild(bomb)
        
        let moveBomb = SKAction.move(to: CGPoint(x: 320, y: 0), duration: 8)
        let rotateBomb = SKAction.rotate(byAngle: -20, duration: 8)
        let groupBomb = SKAction.group([moveBomb, rotateBomb])
        bomb.run(SKAction.repeatForever(groupBomb))
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
        rightSquirrel.physicsBody = SKPhysicsBody(rectangleOf: rightSquirrel.size)
        rightSquirrel.physicsBody?.isDynamic = true
        rightSquirrel.physicsBody?.categoryBitMask = PhysicsCategory.Squirrel
        rightSquirrel.physicsBody?.contactTestBitMask = PhysicsCategory.Bomb
        rightSquirrel.physicsBody?.collisionBitMask = PhysicsCategory.None
        rightSquirrel.physicsBody?.usesPreciseCollisionDetection = true
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
