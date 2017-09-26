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
    var connectedPlayers = [Player]()
    
    @IBOutlet weak var test: UINavigationItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerService.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell", for: indexPath) as? PlayerCell {
            let player = connectedPlayers[indexPath.row]
            cell.updateUI(player: player)
            
            return cell
       
        } else {
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return connectedPlayers.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let playerCell = connectedPlayers[indexPath.row]
        performSegue(withIdentifier: "GameViewController", sender: playerCell)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? GameViewController {
            
            if let player = sender as? Player {
                destination.playerCell = player
           }
        }
    }
}

extension ConnectionsVC : MultiplayerServiceManagerDelegate {
    
    func connectedDevicesChanged(manager: MultiplayerServiceManager, connectedDevices: [String]) {
        OperationQueue.main.addOperation {
            
          
            if(connectedDevices.count != 0) {
                for i in 0..<self.connectedPlayers.count {
                    self.connectedPlayers.remove(at: i)
                }
                
                for i in 0..<connectedDevices.count {
                    self.connectedPlayers.append(Player.init(name: connectedDevices[i], delegate: manager.delegate!))
                }
                    self.tableView.reloadData()
                }
       
    
        }
    }
    
    
    
    func bombAttack(manager: MultiplayerServiceManager, colorString: String) {
        
    }
    
    func getManager() -> MultiplayerServiceManager {
        return self.playerService
    }
    
    
  }

