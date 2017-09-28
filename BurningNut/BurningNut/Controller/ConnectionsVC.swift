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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        tableView.delegate = self
        tableView.dataSource = self
        
        appDelegate.multiplayerManager.delegate = self
        appDelegate.multiplayerManager.browser.startBrowsingForPeers()
        appDelegate.multiplayerManager.advertiser.startAdvertisingPeer()
        
    }
    
    @IBAction func dismissBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        appDelegate.multiplayerManager.session.disconnect()
        appDelegate.multiplayerManager.browser.stopBrowsingForPeers()
        appDelegate.multiplayerManager.advertiser.stopAdvertisingPeer()
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
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPeer = appDelegate.multiplayerManager.foundPeers[indexPath.row] as MCPeerID
        appDelegate.multiplayerManager.browser.invitePeer(selectedPeer, to: appDelegate.multiplayerManager.session, withContext: nil, timeout: 20)
    }
    
    func foundPeer() {
        tableView.reloadData()
    }
    
    
    func lostPeer() {
        tableView.reloadData()
    }
    
    func invitationWasReceived(fromPeer: String) {
        let alert = UIAlertController(title: "", message: "\(fromPeer) will mit dir spielen", preferredStyle: UIAlertControllerStyle.alert)
        
        let acceptAction: UIAlertAction = UIAlertAction(title: "Annehmen", style: UIAlertActionStyle.default) { (alertAction) -> Void in
            GameState.shared.playerNumber = 2
            self.appDelegate.multiplayerManager.invitationHandler(true, self.appDelegate.multiplayerManager.session)
        }
        
        let declineAction = UIAlertAction(title: "Abbrechen", style: UIAlertActionStyle.cancel) { (alertAction) -> Void in
            self.appDelegate.multiplayerManager.invitationHandler(false, nil)
        }
        
        alert.addAction(acceptAction)
        alert.addAction(declineAction)
        
        OperationQueue.main.addOperation { () -> Void in
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func connectedWithPeer(peerID: MCPeerID) {
        
        appDelegate.multiplayerManager.browser.stopBrowsingForPeers()
        appDelegate.multiplayerManager.advertiser.stopAdvertisingPeer()
        
        OperationQueue.main.addOperation { () -> Void in
            self.performSegue(withIdentifier: "GameViewController", sender: self)
        }
    }
    
    func bombAttack(position: String) {
        print(position)
    }
}
