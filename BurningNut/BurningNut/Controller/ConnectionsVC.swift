//
//  ConnectionsVC.swift
//  BurningNut
//
//  Created by Tim Olbrich on 25.09.17.
//  Copyright © 2017 Tim Olbrich. All rights reserved.
//

import UIKit

class ConnectionsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let playerService = MultiplayerServiceManager()
    var connectedPlayers: [String]!
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerService.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell", for: indexPath) as? PlayerCell {
            let player = connectedPlayers[indexPath.row]
            cell.updateUI(player: player + "1")
            
            return cell
       
        } else {
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       /* if(connectedPlayers != nil) {
         return connectedPlayers.count
        } else {
            self.connectedPlayers.append("Keine Spieler gefunden")
         return connectedPlayers.count
        } */
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

extension ConnectionsVC : MultiplayerServiceManagerDelegate {
    
    func connectedDevicesChanged(manager: MultiplayerServiceManager, connectedDevices: [String]) {
        OperationQueue.main.addOperation {
            self.navigationController?.title = connectedDevices[0]
            //self.connectedPlayers = connectedDevices
       
    
        }
    }
    
    func bombAttack(manager: MultiplayerServiceManager, colorString: String) {
        
    }
}
