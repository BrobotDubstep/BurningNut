//
//  GameOverScene.swift
//  BurningNut
//
//  Created by Victor Gerling on 25.09.17.
//  Copyright © 2017 Tim Olbrich. All rights reserved.
//

import Foundation
import SpriteKit

class LocalGameOver: SKScene {
    
    init(size: CGSize, won:Bool) {
        
        super.init(size: size)
        
        backgroundColor = SKColor.white
        var message = String()
        if(!won) {
            message = "Spieler 1 hat gewonnen!"
        } else {
            message = "Spieler 2 hat gewonnen!"
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
                
                if let scene = SKScene(fileNamed: "GameSceneLocal") {
                    let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                    scene.scaleMode = .aspectFill
                    self.view?.presentScene(scene, transition:reveal)
                }
            }
            ]))
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
