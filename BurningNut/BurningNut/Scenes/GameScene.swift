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
    static let None             : UInt32 = 0
    static let All              : UInt32 = UInt32.max
    static let RightSquirrel    : UInt32 = 0x1 << 0
    static let LeftSquirrel     : UInt32 = 0x1 << 1
    static let LeftBomb         : UInt32 = 0x1 << 2
    static let RightBomb        : UInt32 = 0x1 << 3
    static let Environment      : UInt32 = 0x1 << 4
    static let Frame            : UInt32 = 0x1 << 5
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var bombCounter = 0
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    var rightPointLbl = SKLabelNode()
    var leftPointLbl = SKLabelNode()
    let leftSquirrel = SKSpriteNode(imageNamed: "minisquirrelRight")
    let rightSquirrel = SKSpriteNode(imageNamed: "minisquirrel")
    let middleTree = SKSpriteNode(imageNamed: "tree-2")
    let leftTree = SKSpriteNode(imageNamed: "tree-1")
    let rightTree = SKSpriteNode(imageNamed: "tree-1")
    let explosionSound = SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: true)
    var playerTurn = 1
    var playerNumber = 0
    var playerTurnLbl = SKLabelNode()
    var flugbahnCalc = CalcFlugbahn()
    var playerTurnTxt = "Du bist dran!"
    
    var direction = SKShapeNode()
    
    
    override func didMove(to view: SKView) {
        
        self.setupMatchfield()
        
        playerNumber = GameState.shared.playerNumber
        
        if(playerNumber == 1) {
            playerTurnLbl.text = playerTurnTxt
        } else {
            playerTurnLbl.text = ""
        }
        
        leftPointLbl.text = String(GameState.shared.leftScore)
        rightPointLbl.text = String(GameState.shared.rightScore)
        
        self.physicsWorld.gravity = CGVector.init(dx: 0.0, dy: -6)
        self.physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.categoryBitMask = PhysicsCategory.Frame
        self.physicsBody?.contactTestBitMask = PhysicsCategory.LeftSquirrel | PhysicsCategory.RightSquirrel
        
        NotificationCenter.default.addObserver(self, selector: #selector(bombAttack(notification:)), name: NSNotification.Name("bomb"), object: nil)
    }
    
    @objc func bombAttack(notification: NSNotification) {
        guard let text = notification.userInfo?["position"] as? String else { return }
        var squirrel = SKSpriteNode()
        if(playerTurn == 1) {
            squirrel = leftSquirrel
        } else {
            squirrel = rightSquirrel
        }
        addBomb(player: squirrel, position: CGPointFromString(text))
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if contact.bodyA.categoryBitMask == PhysicsCategory.Frame || contact.bodyB.categoryBitMask == PhysicsCategory.Frame {
            if(contact.bodyA.node == leftSquirrel || contact.bodyB.node == leftSquirrel) {
                bombCounter = 1
                GameState.shared.rightScore += 1
                rightPointLbl.text = String(GameState.shared.rightScore)
                if(playerNumber == 1) {
                    playerTurnLbl.text = "Du wurdest getroffen"
                } else {
                    playerTurnLbl.text = "Treffer!"
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                    self.resetGameScene()
                })
                
            } else if(contact.bodyA.node == rightSquirrel || contact.bodyB.node == rightSquirrel) {
                bombCounter = 1
                GameState.shared.leftScore += 1
                leftPointLbl.text = String(GameState.shared.leftScore)
                if(playerNumber == 2) {
                    playerTurnLbl.text = "Du wurdest getroffen"
                } else {
                    playerTurnLbl.text = "Treffer!"
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                    self.resetGameScene()
                })
            }
            if( GameState.shared.leftScore == 3 || GameState.shared.rightScore == 3) {
                gameOver()
                
            }
        }
        else if let bodyOne = contact.bodyA.node as? SKSpriteNode, let bodyTwo = contact.bodyB.node as? SKSpriteNode {
            bombExplode(bodyOne: bodyOne, bodyTwo: bodyTwo)
            if contact.bodyA.node == leftSquirrel || contact.bodyB.node == leftSquirrel || contact.bodyA.node == rightSquirrel || contact.bodyB.node == rightSquirrel  {
                if(contact.bodyA.node == leftSquirrel || contact.bodyB.node == leftSquirrel) {
                    bombCounter = 1
                    GameState.shared.rightScore += 1
                    rightPointLbl.text = String(GameState.shared.rightScore)
                    if(playerNumber == 1) {
                        playerTurnLbl.text = "Du wurdest getroffen"
                    } else {
                        playerTurnLbl.text = "Treffer!"
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                        self.resetGameScene()
                    })
                    
                } else if(contact.bodyA.node == rightSquirrel || contact.bodyB.node == rightSquirrel) {
                    bombCounter = 1
                    GameState.shared.leftScore += 1
                    leftPointLbl.text = String(GameState.shared.leftScore)
                    if(playerNumber == 2) {
                        playerTurnLbl.text = "Du wurdest getroffen"
                    } else {
                        playerTurnLbl.text = "Treffer!"
                    }
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
            var playerBool: Bool
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            if(self.playerTurn == 1) {
                playerBool = true
            } else {
                playerBool = false
            }
            let gameOverScene = GameOverScene(size: self.size, won: playerBool)
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
        
        if(self.playerTurn == 1) {
            self.playerTurn = 2
            if(self.playerNumber == 2) {
                self.playerTurnLbl.text = self.playerTurnTxt
            } else {
                self.playerTurnLbl.text = ""
            }
            
        } else {
            self.playerTurn = 1
            self.playerTurnLbl.text = ""
            if(playerNumber == 1) {
                playerTurnLbl.text = playerTurnTxt
            } else {
                playerTurnLbl.text = ""
            }
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
            
            if(self.playerTurn == 1) {
                self.playerTurn = 2
                if(self.playerNumber == 2) {
                    self.playerTurnLbl.text = self.playerTurnTxt
                } else {
                    self.playerTurnLbl.text = ""
                }
                
            } else {
                self.playerTurn = 1
                self.playerTurnLbl.text = ""
                if(self.playerNumber == 1) {
                    self.playerTurnLbl.text = self.playerTurnTxt
                } else {
                    self.playerTurnLbl.text = ""
                }
            }
        }
    }
    
    func addBomb(player: SKSpriteNode, position: CGPoint) {
        
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
            bomb.physicsBody?.contactTestBitMask = physicsCategory | PhysicsCategory.Environment
            //bomb.physicsBody?.collisionBitMask = physicsCategory
            bomb.physicsBody?.affectedByGravity = false
            
            
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
        
        if(playerNumber == playerTurn) {
            direction.removeFromParent()
            var currentPlayer: SKSpriteNode
            guard let touch = touches.first else {
                return
            }
            let touchLocation = touch.location(in: self)
            
            if(playerTurn == 1) {
                currentPlayer = leftSquirrel
            } else {
                currentPlayer = rightSquirrel
            }
            
            addBomb(player: currentPlayer, position: touchLocation)
            appDelegate.multiplayerManager.sendData(position: NSStringFromCGPoint(touchLocation))
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if(playerNumber == playerTurn) {
            
            direction.removeFromParent()
            var currentPlayer: SKSpriteNode
            guard let touch = touches.first else {
                return
            }
            let touchLocation = touch.location(in: self)
            
            let bezierPath = UIBezierPath()
            
            if(playerTurn == 1) {
                currentPlayer = leftSquirrel
                let a = atan((touchLocation.y - currentPlayer.position.y) / (touchLocation.x - currentPlayer.position.x))
                let x = currentPlayer.position.x + 160 * cos(a)
                let y = currentPlayer.position.y + 160 * sin(a)
                
                bezierPath.move(to: currentPlayer.position)
                bezierPath.addLine(to: CGPoint(x: x, y: y))
            } else {
                currentPlayer = rightSquirrel
                let a = atan((touchLocation.y - currentPlayer.position.y) / (touchLocation.x - currentPlayer.position.x))
                let x = currentPlayer.position.x - 160 * cos(a)
                let y = currentPlayer.position.y - 160 * sin(a)
                
                bezierPath.move(to: currentPlayer.position)
                bezierPath.addLine(to: CGPoint(x: x, y: y))
            }
            
            direction.path = bezierPath.cgPath
            direction.fillColor = .white
            direction.lineWidth = 2
            direction.zPosition = 0
            addChild(direction)
            
        }
    }
    
    func setupMatchfield() {
        
        playerTurnLbl.position = CGPoint(x: 0, y: 135)
        playerTurnLbl.zPosition = 7
        playerTurnLbl.fontColor = UIColor.black
        addChild(playerTurnLbl)
        
        leftPointLbl.position = CGPoint(x: -310, y: 135)
        leftPointLbl.zPosition = 7
        leftPointLbl.fontColor = UIColor.black
        addChild(leftPointLbl)
        
        rightPointLbl.position = CGPoint(x: 310, y: 135)
        rightPointLbl.zPosition = 7
        rightPointLbl.fontColor = UIColor.black
        addChild(rightPointLbl)
        
        leftSquirrel.position = CGPoint(x: -300.839, y: -89.305)
        leftSquirrel.size = CGSize(width: 51.321, height: 59.464)
        leftSquirrel.anchorPoint.x = 0.5
        leftSquirrel.anchorPoint.y = 0.5
        leftSquirrel.zPosition = 1
        leftSquirrel.physicsBody = SKPhysicsBody(rectangleOf: leftSquirrel.size)
        //leftSquirrel.physicsBody?.isDynamic = false
        leftSquirrel.physicsBody?.categoryBitMask = PhysicsCategory.LeftSquirrel
        leftSquirrel.physicsBody?.contactTestBitMask = PhysicsCategory.RightBomb | PhysicsCategory.Frame
        leftSquirrel.physicsBody?.collisionBitMask = PhysicsCategory.Environment
        addChild(leftSquirrel)
        
        rightSquirrel.position = CGPoint(x: 300.839, y: -89.305)
        rightSquirrel.size = CGSize(width: 51.321, height: 59.464)
        rightSquirrel.anchorPoint.x = 0.5
        rightSquirrel.anchorPoint.y = 0.5
        rightSquirrel.zPosition = 1
        rightSquirrel.physicsBody = SKPhysicsBody(rectangleOf: rightSquirrel.size)
        //rightSquirrel.physicsBody?.isDynamic = false
        rightSquirrel.physicsBody?.categoryBitMask = PhysicsCategory.RightSquirrel
        rightSquirrel.physicsBody?.contactTestBitMask = PhysicsCategory.LeftBomb | PhysicsCategory.Frame
        rightSquirrel.physicsBody?.collisionBitMask = PhysicsCategory.Environment
        addChild(rightSquirrel)
        
        middleTree.position = CGPoint(x: 0, y: -4.238)
        middleTree.size = CGSize(width: 124.354, height: 221.849)
        middleTree.anchorPoint.x = 0.5
        middleTree.anchorPoint.y = 0.5
        middleTree.zPosition = 1
        middleTree.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 10, height: middleTree.size.height))
        middleTree.physicsBody?.categoryBitMask = PhysicsCategory.Environment
        middleTree.physicsBody?.contactTestBitMask = PhysicsCategory.LeftBomb | PhysicsCategory.RightBomb
        middleTree.physicsBody?.collisionBitMask = PhysicsCategory.Environment
        //middleTree.physicsBody?.affectedByGravity = false
        addChild(middleTree)
        
        leftTree.position = CGPoint(x: -147.94, y: -62.205)
        leftTree.size = CGSize(width: 119.261, height: 173.357)
        leftTree.anchorPoint.x = 0.5
        leftTree.anchorPoint.y = 0.5
        leftTree.zPosition = 1
        leftTree.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 10, height: leftTree.size.height))
        leftTree.physicsBody?.categoryBitMask = PhysicsCategory.Environment
        leftTree.physicsBody?.contactTestBitMask = PhysicsCategory.LeftBomb | PhysicsCategory.RightBomb
        leftTree.physicsBody?.collisionBitMask = PhysicsCategory.Environment
        //leftTree.physicsBody?.affectedByGravity = false
        addChild(leftTree)
        
        rightTree.position = CGPoint(x: 147.94, y: -62.205)
        rightTree.size = CGSize(width: 119.261, height: 173.357)
        rightTree.anchorPoint.x = 0.5
        rightTree.anchorPoint.y = 0.5
        rightTree.zPosition = 1
        rightTree.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 10, height: rightTree.size.height))
        rightTree.physicsBody?.categoryBitMask = PhysicsCategory.Environment
        rightTree.physicsBody?.contactTestBitMask = PhysicsCategory.LeftBomb | PhysicsCategory.RightBomb
        rightTree.physicsBody?.collisionBitMask = PhysicsCategory.Environment
        //rightTree.physicsBody?.affectedByGravity = false
        addChild(rightTree)
    }
}
