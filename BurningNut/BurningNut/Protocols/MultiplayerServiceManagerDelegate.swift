//
//  MultiplayerServiceManagerDelegate.swift
//  BurningNut
//
//  Created by Victor Gerling on 22.09.17.
//  Copyright © 2017 Tim Olbrich. All rights reserved.
//

protocol MultiplayerServiceManagerDelegate {
    
    func connectedDevicesChanged(manager : MultiplayerServiceManager, connectedDevices: [String])
    func bombAttack(manager : MultiplayerServiceManager, colorString: String)
    
}
