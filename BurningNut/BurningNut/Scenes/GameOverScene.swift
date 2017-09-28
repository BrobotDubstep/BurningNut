//
//  GameOverScene.swift
//  BurningNut
//
//  Created by Victor Gerling on 25.09.17.
//  Copyright © 2017 Tim Olbrich. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    
    init(size: CGSize, won:Bool) {
        
        super.init(size: size)
        
        backgroundColor = SKColor.white
        var message = String()
        if(GameState.shared.playerNumber == 1 && !won || GameState.shared.playerNumber == 2 && won) {
            message = "Du hast gewonnen!"
        } else {
            message = "Du hast leider verloren!"
        }
        
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = message
        label.fontSize = 40
        label.fontColor = SKColor.black
        label.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(label)
        
        GameState.shared.leftScore = 0
        GameState.shared.rightScore = 0
        
        run(SKAction.sequence([
            SKAction.wait(forDuration: 3.0),
            SKAction.run() {
                let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                let scene = GameScene(size: size)
                scene.scaleMode = .aspectFill
                self.view?.presentScene(scene, transition:reveal)
            }
            ]))
    }
    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//
//        GameState.shared.leftScore = 0
//        GameState.shared.rightScore = 0
//
//        if let view = self.view as SKView? {
//            if let scene = SKScene(fileNamed: "GameScene") {
//                scene.scaleMode = .aspectFill
//                view.presentScene(scene)
//            }
//
//            view.ignoresSiblingOrder = true
//
//        }
//    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
