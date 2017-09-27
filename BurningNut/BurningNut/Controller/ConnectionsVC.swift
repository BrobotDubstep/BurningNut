//
//  ConnectionsVC.swift
//  BurningNut
//
//  Created by Tim Olbrich on 25.09.17.
//  Copyright © 2017 Tim Olbrich. All rights reserved.
//

import UIKit
import MultipeerConnectivity


class ConnectionsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, MultiplayerServiceManagerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
//    let playerService = MultiplayerServiceManager()
//    var connectedPlayers = [Player]()
    
    @IBOutlet weak var test: UINavigationItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //playerService.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        appDelegate.multiplayerManager.delegate = self
        appDelegate.multiplayerManager.browser.startBrowsingForPeers()
        appDelegate.multiplayerManager.advertiser.startAdvertisingPeer()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.multiplayerManager.foundPeers.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell", for: indexPath) as? PlayerCell {
        
        cell.playerLbl.text = appDelegate.multiplayerManager.foundPeers[indexPath.row].displayName
        
         return cell
        } else {
            return UITableViewCell()
        }
    }
    
    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return 60.0
//    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPeer = appDelegate.multiplayerManager.foundPeers[indexPath.row] as MCPeerID
        
        appDelegate.multiplayerManager.browser.invitePeer(selectedPeer, to: appDelegate.multiplayerManager.session, withContext: nil, timeout: 20)
    }
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell", for: indexPath) as? PlayerCell {
//            let player = connectedPlayers[indexPath.row]
//            cell.updateUI(player: player)
//
//            return cell
//
//        } else {
//            return UITableViewCell()
//        }
//
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//         return connectedPlayers.count
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let playerCell = connectedPlayers[indexPath.row]
//        performSegue(withIdentifier: "GameViewController", sender: playerCell)
//    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        if let destination = segue.destination as? GameViewController {
//
//            if let player = sender as? Player {
//                destination.playerCell = player
//           }
//        }
//    }
    
    func foundPeer() {
        tableView.reloadData()
    }
    
    
    func lostPeer() {
        tableView.reloadData()
    }
    
    func invitationWasReceived(fromPeer: String) {
        let alert = UIAlertController(title: "", message: "\(fromPeer) wants to chat with you.", preferredStyle: UIAlertControllerStyle.alert)
        
        let acceptAction: UIAlertAction = UIAlertAction(title: "Accept", style: UIAlertActionStyle.default) { (alertAction) -> Void in
            self.appDelegate.multiplayerManager.invitationHandler(true, self.appDelegate.multiplayerManager.session)
        }
        
        let declineAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (alertAction) -> Void in
            self.appDelegate.multiplayerManager.invitationHandler(false, nil)
        }
        
        alert.addAction(acceptAction)
        alert.addAction(declineAction)
        
        OperationQueue.main.addOperation { () -> Void in
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func connectedWithPeer(peerID: MCPeerID) {
        OperationQueue.main.addOperation { () -> Void in
            self.performSegue(withIdentifier: "GameViewController", sender: self)
        }
    }
}

//extension ConnectionsVC : MultiplayerServiceManagerDelegate {
//
//    func connectedDevicesChanged(manager: MultiplayerServiceManager, connectedDevices: [String]) {
//        OperationQueue.main.addOperation {
//
//
//            if(connectedDevices.count != 0) {
//                for i in 0..<self.connectedPlayers.count {
//                    self.connectedPlayers.remove(at: i)
//                }
//
//                for i in 0..<connectedDevices.count {
//                    self.connectedPlayers.append(Player.init(name: connectedDevices[i], delegate: manager.delegate!))
//                }
//                    self.tableView.reloadData()
//                }
//        }
//    }
//
//
//
//    func bombAttack(manager: MultiplayerServiceManager, colorString: String) {
//
//    }
//
//    func getManager() -> MultiplayerServiceManager {
//        return self.playerService
//    }
//
//
//  }

