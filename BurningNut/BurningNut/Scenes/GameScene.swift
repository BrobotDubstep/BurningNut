//
//  GameScene.swift
//  BurningNut
//
//  Created by Tim Olbrich on 21.09.17.
//  Copyright © 2017 Tim Olbrich. All rights reserved.
//

import SpriteKit
import GameplayKit
import MultipeerConnectivity

struct PhysicsCategory {
    static let None      : UInt32 = 0
    static let All       : UInt32 = UInt32.max
    static let RightSquirrel: UInt32 = 0b10
    static let LeftSquirrel: UInt32 = 0b1
    static let LeftBomb: UInt32 = 0b11
    static let RightBomb: UInt32 = 0b100

}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var rightPointLbl = SKLabelNode()
    var leftPointLbl = SKLabelNode()
    let leftSquirrel = SKSpriteNode(imageNamed: "minisquirrelRight")
    let rightSquirrel = SKSpriteNode(imageNamed: "minisquirrel")
    let middleTree = SKSpriteNode(imageNamed: "tree-2")
    let leftTree = SKSpriteNode(imageNamed: "tree-1")
    let rightTree = SKSpriteNode(imageNamed: "tree-1")
    let explosionSound = SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: true)
    var player1Turn = true
    var flugbahnCalc = CalcFlugbahn()
    
    
   

    override func didMove(to view: SKView) {
        
        self.setupMatchfield()
        
        leftPointLbl.text = String(GameState.shared.leftScore)
        rightPointLbl.text = String(GameState.shared.rightScore)
        
        self.physicsWorld.gravity = CGVector.init(dx: 0.0, dy: 0)
        physicsWorld.contactDelegate = self
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if (contact.bodyA.node == leftSquirrel && contact.bodyB.categoryBitMask == PhysicsCategory.LeftBomb) ||
            (contact.bodyA.node == rightSquirrel && contact.bodyB.categoryBitMask == PhysicsCategory.RightBomb) ||
            (contact.bodyB.node == rightSquirrel && contact.bodyA.categoryBitMask == PhysicsCategory.RightBomb) ||
            (contact.bodyB.node == rightSquirrel && contact.bodyA.categoryBitMask == PhysicsCategory.RightBomb) {
            return
        }
        
        if let bodyOne = contact.bodyA.node as? SKSpriteNode, let bodyTwo = contact.bodyB.node as? SKSpriteNode {
            bombExplode(bodyOne: bodyOne, bodyTwo: bodyTwo)
            if contact.bodyA.node == leftSquirrel || contact.bodyB.node == leftSquirrel || contact.bodyA.node == rightSquirrel || contact.bodyB.node == rightSquirrel  {
                if(contact.bodyA.node == leftSquirrel || contact.bodyB.node == leftSquirrel) {
                    bombCounter = 1
                    GameState.shared.rightScore += 1
                    rightPointLbl.text = String(GameState.shared.rightScore)
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                        self.resetGameScene()
                    })
               
                } else if(contact.bodyA.node == rightSquirrel || contact.bodyB.node == rightSquirrel) {
                    bombCounter = 1
                    GameState.shared.leftScore += 1
                    leftPointLbl.text = String(GameState.shared.leftScore)
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                        self.resetGameScene()
                    })
                }
                if( GameState.shared.leftScore == 3 || GameState.shared.rightScore == 3) {
                    gameOver()
                    
                }
        }

        }
    }
    
    func gameOver(){
        let loseAction = SKAction.run() {
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameOverScene = GameOverScene(size: self.size, won: self.player1Turn)
            self.view?.presentScene(gameOverScene, transition: reveal)
        }
        run(loseAction)
    }
    
    func bombExplode(bodyOne: SKSpriteNode, bodyTwo: SKSpriteNode) {
        
        let explosion = SKSpriteNode(imageNamed: "explosion")
        explosion.position = bodyOne.position
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
        bodyOne.removeFromParent()
        bodyTwo.removeFromParent()
        
        bombCounter = 0
        
        if(player1Turn) {
            player1Turn = false
        } else {
            player1Turn = true
        }
    }
    
    func bombDidNotHit(leBomb: SKSpriteNode) -> SKAction {
        return SKAction.run {
        let explosion = SKSpriteNode(imageNamed: "explosion")
        explosion.position = leBomb.position
        explosion.size = CGSize(width: 60, height: 60)
        explosion.zPosition = 1
        self.addChild(explosion)
        self.run(self.explosionSound)
        
        explosion.run(
            SKAction.sequence([
                SKAction.wait(forDuration: 1.0),
                SKAction.removeFromParent()
                ])
        )
            leBomb.removeFromParent()
            
            self.bombCounter = 0
            
            if(self.player1Turn) {
                self.player1Turn = false
            } else {
                self.player1Turn = true
            }
        }
    }
    
    func addBomb(player: SKSpriteNode, position: CGPoint) {
        
        appDelegate.multiplayerManager.sendData(position: NSStringFromCGPoint(position))
        
        var physicsCategory: UInt32
        var bombCategory: UInt32
        var loopFrom, loopTo: CGFloat
        var loopStep: CGFloat
        
        if(player == leftSquirrel) {
            physicsCategory = PhysicsCategory.RightSquirrel
            bombCategory = PhysicsCategory.LeftBomb
            loopFrom = leftSquirrel.position.x
            loopTo = rightSquirrel.position.x
            loopStep = 1
        } else {
            physicsCategory = PhysicsCategory.LeftSquirrel
            bombCategory = PhysicsCategory.RightBomb
            loopFrom = rightSquirrel.position.x
            loopTo = leftSquirrel.position.x
            loopStep = -1
        }
        
        if(bombCounter == 0) {
        let bomb = SKSpriteNode(imageNamed: "bomb")
        bomb.position = CGPoint(x: player.position.x, y: player.position.y)
        bomb.size = CGSize(width: 15, height: 30)
        bomb.zPosition = 1
        
        bomb.physicsBody = SKPhysicsBody(rectangleOf: bomb.size)
        bomb.physicsBody?.categoryBitMask = bombCategory
        bomb.physicsBody?.contactTestBitMask = PhysicsCategory.All
        bomb.physicsBody?.collisionBitMask = physicsCategory

        
        addChild(bomb)
        bombCounter += 1
        
        //let moveBomb = SKAction.move(to: CGPoint(x: position.x, y: position.y), duration: 4)
        
        let bezierPath = UIBezierPath()
        bezierPath.move(to: player.position)
        
        for i in stride(from: loopFrom, to: loopTo, by: loopStep) {
            let nextPoint = flugbahnCalc.flugkurve(t: CGFloat(i), x: player.position.x, y: player.position.y, x_in: position.x, y_in: position.y, player: loopStep)
            bezierPath.addLine(to: CGPoint(x: CGFloat(i), y: nextPoint))
        }
        
        //bezierPath.close()
        
        
        let moveBomb = SKAction.follow(bezierPath.cgPath, asOffset: false, orientToPath: false, duration: 3)
        let rotateBomb = SKAction.rotate(byAngle: -20, duration: 3)
        let removeBomb = bombDidNotHit(leBomb: bomb)
        let groupBomb = SKAction.group([moveBomb, rotateBomb])
        //bomb.run(SKAction.repeatForever(groupBomb))
        bomb.run(SKAction.sequence([groupBomb, removeBomb]))
        
        }
      
        
        
    }
    
    func resetGameScene() {
        
        if let view = self.view as SKView? {
            if let scene = SKScene(fileNamed: "GameScene") {
                scene.scaleMode = .aspectFill
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            //            view.showsFPS = true
            //            view.showsNodeCount = true
        }
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
        
        addBomb(player: currentPlayer, position: touchLocation)
        }
    
    func setupMatchfield() {
        
        leftPointLbl.position = CGPoint(x: -310, y: 135)
        leftPointLbl.zPosition = 7
        leftPointLbl.fontColor = UIColor.black
        addChild(leftPointLbl)
        
        rightPointLbl.position = CGPoint(x: 310, y: 135)
        rightPointLbl.zPosition = 7
        rightPointLbl.fontColor = UIColor.black
        addChild(rightPointLbl)
        
        leftSquirrel.position = CGPoint(x: -307.839, y: -89.305)
        leftSquirrel.size = CGSize(width: 51.321, height: 59.464)
        leftSquirrel.anchorPoint.x = 0.5
        leftSquirrel.anchorPoint.y = 0.5
        leftSquirrel.zPosition = 1
        leftSquirrel.physicsBody = SKPhysicsBody(rectangleOf: leftSquirrel.size)
        leftSquirrel.physicsBody?.isDynamic = false
        leftSquirrel.physicsBody?.categoryBitMask = PhysicsCategory.LeftSquirrel
        addChild(leftSquirrel)
        
        rightSquirrel.position = CGPoint(x: 307.839, y: -89.305)
        rightSquirrel.size = CGSize(width: 51.321, height: 59.464)
        rightSquirrel.anchorPoint.x = 0.5
        rightSquirrel.anchorPoint.y = 0.5
        rightSquirrel.zPosition = 1
        rightSquirrel.physicsBody = SKPhysicsBody(rectangleOf: rightSquirrel.size)
        rightSquirrel.physicsBody?.isDynamic = false
        rightSquirrel.physicsBody?.categoryBitMask = PhysicsCategory.RightSquirrel
        addChild(rightSquirrel)
        
        middleTree.position = CGPoint(x: 0, y: -4.238)
        middleTree.size = CGSize(width: 124.354, height: 221.849)
        middleTree.anchorPoint.x = 0.5
        middleTree.anchorPoint.y = 0.5
        middleTree.zPosition = 1
        middleTree.physicsBody = SKPhysicsBody(rectangleOf: middleTree.size)
        addChild(middleTree)
        
        leftTree.position = CGPoint(x: -147.94, y: -62.205)
        leftTree.size = CGSize(width: 119.261, height: 173.357)
        leftTree.anchorPoint.x = 0.5
        leftTree.anchorPoint.y = 0.5
        leftTree.zPosition = 1
        leftTree.physicsBody = SKPhysicsBody(rectangleOf: leftTree.size)
        addChild(leftTree)
        
        rightTree.position = CGPoint(x: 147.94, y: -62.205)
        rightTree.size = CGSize(width: 119.261, height: 173.357)
        rightTree.anchorPoint.x = 0.5
        rightTree.anchorPoint.y = 0.5
        rightTree.zPosition = 1
        rightTree.physicsBody = SKPhysicsBody(rectangleOf: rightTree.size)
        addChild(rightTree)
    }
    
  
    
    
}

extension GameScene: MultiplayerServiceManagerDelegate {
    func foundPeer() {
        
    }
    
    func lostPeer() {
        
    }
    
    func invitationWasReceived(fromPeer: String) {
        
    }
    
    func connectedWithPeer(peerID: MCPeerID) {
        
    }
    
    func bombAttack(position: String) {
        
        addBomb(player: leftSquirrel, position: CGPointFromString(position))
    }
    
    
}
