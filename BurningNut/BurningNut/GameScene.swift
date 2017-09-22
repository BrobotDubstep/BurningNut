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
    static let RightSquirrel: UInt32 = 0b100
    static let LeftSquirrel: UInt32 = 0b11
    static let LeftBomb: UInt32 = 0b1
    static let RightBomb: UInt32 = 0b10

}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let leftSquirrel = SKSpriteNode(imageNamed: "minisquirrelRight")
    let rightSquirrel = SKSpriteNode(imageNamed: "minisquirrel")
    let middleTree = SKSpriteNode(imageNamed: "tree-2")
    let leftTree = SKSpriteNode(imageNamed: "tree-1")
    let rightTree = SKSpriteNode(imageNamed: "tree-1")
    let explosionSound = SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: true)
    var player1Turn = true
   

    override func didMove(to view: SKView) {
        
        self.setupMatchfield()
        
        self.physicsWorld.gravity = CGVector.init(dx: 0.0, dy: 0)
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

        if ((firstBody.categoryBitMask & PhysicsCategory.LeftSquirrel != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.RightBomb != 0)) {
            if let monster = firstBody.node as? SKSpriteNode, let
                projectile = secondBody.node as? SKSpriteNode {
                bombExplode(bomb: projectile, squirrel: monster)
            }
        } else if((firstBody.categoryBitMask & PhysicsCategory.RightSquirrel != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.LeftBomb != 0)) {
            if let monster = firstBody.node as? SKSpriteNode, let
                projectile = secondBody.node as? SKSpriteNode {
                bombExplode(bomb: projectile, squirrel: monster)
            }
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        

        
    }
    
    func playerTurn(player: SKSpriteNode, position: CGPoint) {
        
        addBomb(player: player, position: position)
        
    
    }
    
    func bombExplode(bomb: SKSpriteNode, squirrel: SKSpriteNode) {
        
        let explosion = SKSpriteNode(imageNamed: "explosion")
        explosion.position = bomb.position
        explosion.size = CGSize(width: 60, height: 60)
        explosion.zPosition = 1
        addChild(explosion)
        run(explosionSound)
        
        explosion.run(
            SKAction.sequence([
                SKAction.wait(forDuration: 1.0),
                SKAction.removeFromParent()
                ])
        )
        bomb.removeFromParent()
        squirrel.removeFromParent()
    }
    
    func addBomb(player: SKSpriteNode, position: CGPoint) {
        
        var physicsCategory: UInt32
        var bombCategory: UInt32
        var opponent: SKSpriteNode
        
        if(player == leftSquirrel) {
            physicsCategory = PhysicsCategory.RightSquirrel
            bombCategory = PhysicsCategory.LeftBomb
            opponent = rightSquirrel
        } else {
            physicsCategory = PhysicsCategory.LeftSquirrel
            opponent = leftSquirrel
            bombCategory = PhysicsCategory.RightBomb
        }
        
        let bomb = SKSpriteNode(imageNamed: "bomb")
        bomb.position = CGPoint(x: player.position.x, y: player.position.y)
        bomb.size = CGSize(width: 15, height: 30)
        bomb.zPosition = 1
        
        bomb.physicsBody = SKPhysicsBody(rectangleOf: bomb.size)
        opponent.physicsBody?.isDynamic = false
        bomb.physicsBody?.categoryBitMask = bombCategory
        bomb.physicsBody?.contactTestBitMask = physicsCategory
        bomb.physicsBody?.collisionBitMask = PhysicsCategory.None

        addChild(bomb)
        
        let moveBomb = SKAction.move(to: CGPoint(x: position.x, y: position.y), duration: 4)
        let rotateBomb = SKAction.rotate(byAngle: -20, duration: 4)
        let groupBomb = SKAction.group([moveBomb, rotateBomb])
        bomb.run(SKAction.repeatForever(groupBomb))
        
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
      
        
        var currentPlayer: SKSpriteNode
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        
        if(player1Turn == true) {
            currentPlayer = leftSquirrel
        } else {
            currentPlayer = rightSquirrel
        }
        
        //playerTurn(player: currentPlayer, position: touchLocation)
        
        addBomb(player: currentPlayer, position: touchLocation)
        
        if(player1Turn) {
            player1Turn = false
        } else {
            player1Turn = true
        }
        
        
        }
    
    func setupMatchfield() {
        
        leftSquirrel.position = CGPoint(x: -307.839, y: -89.305)
        leftSquirrel.size = CGSize(width: 51.321, height: 59.464)
        leftSquirrel.anchorPoint.x = 0.5
        leftSquirrel.anchorPoint.y = 0.5
        leftSquirrel.zPosition = 1
        leftSquirrel.physicsBody = SKPhysicsBody(rectangleOf: leftSquirrel.size)
        leftSquirrel.physicsBody?.isDynamic = false
        leftSquirrel.physicsBody?.categoryBitMask = PhysicsCategory.LeftSquirrel
        leftSquirrel.physicsBody?.contactTestBitMask = PhysicsCategory.RightBomb
        leftSquirrel.physicsBody?.collisionBitMask = PhysicsCategory.None
        leftSquirrel.physicsBody?.usesPreciseCollisionDetection = true
        addChild(leftSquirrel)
        
        rightSquirrel.position = CGPoint(x: 307.839, y: -89.305)
        rightSquirrel.size = CGSize(width: 51.321, height: 59.464)
        rightSquirrel.anchorPoint.x = 0.5
        rightSquirrel.anchorPoint.y = 0.5
        rightSquirrel.zPosition = 1
        rightSquirrel.physicsBody = SKPhysicsBody(rectangleOf: rightSquirrel.size)
        rightSquirrel.physicsBody?.isDynamic = false
        rightSquirrel.physicsBody?.categoryBitMask = PhysicsCategory.RightSquirrel
        rightSquirrel.physicsBody?.contactTestBitMask = PhysicsCategory.LeftBomb
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
