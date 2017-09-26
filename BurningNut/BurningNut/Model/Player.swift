//
//  Player.swift
//  BurningNut
//
//  Created by Tim Olbrich on 26.09.17.
//  Copyright © 2017 Tim Olbrich. All rights reserved.
//

import Foundation

class Player {
    private let _name: String!
    private let _delegate: MultiplayerServiceManagerDelegate!
    
    var name: String {
        return _name
    }
    
    var delegate: MultiplayerServiceManagerDelegate {
        return _delegate
    }

    init(name: String, delegate: MultiplayerServiceManagerDelegate) {
        _name = name
        _delegate = delegate
    }
}
