//
//  GameScore.swift
//  BurningNut
//
//  Created by Tim Olbrich on 27.09.17.
//  Copyright © 2017 Tim Olbrich. All rights reserved.
//

import Foundation

class GameScore {
    static let shared = GameScore()
    var leftScore = 0
    var rightScore = 0
    
    private init() { }
}
